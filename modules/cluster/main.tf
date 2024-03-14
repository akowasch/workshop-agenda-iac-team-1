################################################################################
# Locals

locals {
  tags = merge(var.tags, {
    Module = "devops-platform/gitlab/runner/azure-runner/iac/modules/cluster"
  })
}

################################################################################
# User Assigned Identity

resource "azurerm_user_assigned_identity" "cluster" {
  name                = "uai-${var.infix}-${var.name}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

################################################################################
# Role Assignments

data "azurerm_subscription" "this" {}

resource "azurerm_role_assignment" "cluster_contributor" {
  principal_id                     = azurerm_user_assigned_identity.cluster.principal_id
  scope                            = data.azurerm_subscription.this.id
  role_definition_name             = "Contributor"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "kubelet_identity_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  scope                            = var.azure_container_registry_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

################################################################################
# Kubernetes Cluster

resource "azurerm_kubernetes_cluster" "this" {
  name                    = "kc-${var.infix}-${var.name}"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
  node_resource_group     = "${var.resource_group.name}-node-pool"
  dns_prefix              = "kc-${var.infix}-${var.name}"
  sku_tier                = "Standard"
  node_os_channel_upgrade = "Unmanaged"
  kubernetes_version      = var.kubernetes_version

  # Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  #Azure AD authentication with Azure RBAC
  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  dynamic "api_server_access_profile" {
    for_each = var.api_server_authorized_ip_ranges != null ? [1] : []

    content {
      authorized_ip_ranges = var.api_server_authorized_ip_ranges
    }
  }

  default_node_pool {
    zones                       = ["1"]
    name                        = "s1"
    enable_auto_scaling         = false
    node_count                  = 1
    max_pods                    = 250
    vm_size                     = "Standard_E4ads_v5"
    os_disk_type                = "Ephemeral"
    os_disk_size_gb             = 150
    kubelet_disk_type           = "OS"
    temporary_name_for_rotation = "t1"
    vnet_subnet_id              = var.subnet_ids["1"]
    enable_host_encryption      = true
    orchestrator_version        = var.kubernetes_version

    node_labels = {
      "availability-zone" = "1"
    }

    upgrade_settings {
      max_surge = "100%"
    }

    tags = local.tags
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cluster.id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
    outbound_type       = "userAssignedNATGateway"

    dns_service_ip = "192.168.0.10"
    service_cidr   = "192.168.0.0/17"
    pod_cidr       = "192.168.128.0/17"
  }

  storage_profile {
    file_driver_enabled = false
  }

  dynamic "maintenance_window" {
    for_each = [1]

    content {
      dynamic "allowed" {
        for_each = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        content {
          day   = allowed.value
          hours = [1, 2, 3, 4]
        }
      }
    }
  }

  timeouts {
    update = "3h"
  }

  lifecycle {
    ignore_changes = [
      api_server_access_profile[0].authorized_ip_ranges,
      tags,
    ]
  }

  tags = local.tags

  depends_on = [
    azurerm_role_assignment.cluster_contributor
  ]
}

################################################################################
# Node Pools

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = toset(["2", "3"])

  zones                  = [each.value]
  name                   = "s${each.value}"
  mode                   = "System"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.this.id
  enable_auto_scaling    = false
  node_count             = 1
  max_pods               = 250
  vm_size                = "Standard_E4ads_v5"
  os_disk_type           = "Ephemeral"
  os_disk_size_gb        = 150
  kubelet_disk_type      = "OS"
  vnet_subnet_id         = var.subnet_ids[each.value]
  enable_host_encryption = true
  orchestrator_version   = var.kubernetes_version

  node_labels = {
    "availability-zone" = "${each.value}"
  }

  upgrade_settings {
    max_surge = "100%"
  }

  tags = local.tags
}
