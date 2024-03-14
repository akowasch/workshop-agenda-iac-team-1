################################################################################
# Locals

locals {
  availability_zones = toset(["1", "2", "3"])

  node_labels = merge(
    var.node_labels,
    var.node_taints,
    var.priority == "Spot" ? { "kubernetes.azure.com/scalesetpriority" = "spot" } : {},
  )
  node_taints = [
    for k, v in merge(
      var.node_taints,
      var.priority == "Spot" ? { "kubernetes.azure.com/scalesetpriority" = "spot" } : {},
    ) : "${k}=${v}:NoSchedule"
  ]

  tags = merge(var.tags, {
    Module = "devops-platform/gitlab/runner/azure-runner/iac/modules/node-pool"
  })
}

################################################################################
# Kubernetes Cluster Node Pools

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = local.availability_zones

  name                   = "u${var.name}${each.value}"
  kubernetes_cluster_id  = var.cluster_id
  vm_size                = var.vm_size
  mode                   = "User"
  zones                  = [each.value]
  vnet_subnet_id         = var.subnet_ids[each.value]
  orchestrator_version   = var.kubernetes_version
  workload_runtime       = { Linux = "KataMshvVmIsolation", Windows = "OCIContainer" }[var.os_type]
  max_pods               = var.max_pods
  enable_host_encryption = true

  # Operating System
  os_type           = var.os_type
  os_sku            = { Linux = "AzureLinux", Windows = "Windows2022" }[var.os_type]
  os_disk_type      = "Ephemeral"
  os_disk_size_gb   = var.os_disk_size_gb
  kubelet_disk_type = "OS"

  # Autoscaling
  enable_auto_scaling = true
  min_count           = var.min_count
  max_count           = var.max_count

  # Node Labels and Taints
  node_labels = local.node_labels
  node_taints = local.node_taints

  # Regular or Spot Priority
  priority        = var.priority
  eviction_policy = var.priority == "Spot" ? "Delete" : null
  spot_max_price  = var.priority == "Spot" ? -1 : null

  dynamic "windows_profile" {
    for_each = var.os_type == "Windows" ? [1] : []

    content {
      outbound_nat_enabled = true # required if network plugin mode is overlay
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  tags = local.tags
}
