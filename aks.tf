module "aks" {
  source  = "Azure/aks/azurerm"
  version = "8.0.0"

  log_analytics_workspace_enabled = false
  os_disk_size_gb                 = 60
  prefix                          = random_id.prefix.hex
  resource_group_name             = var.resource_group.name
  rbac_aad                        = false
  sku_tier                        = "Standard"
}
