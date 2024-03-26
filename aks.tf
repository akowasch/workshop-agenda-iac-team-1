module "aks" {
  # https://github.com/Azure/terraform-azurerm-aks/tags
  source = "git::https://github.com/Azure/terraform-azurerm-aks.git?ref=a094a4deab23bebcd4dd8f64208514eb1a835482" # 8.0.0

  log_analytics_workspace_enabled = false
  os_disk_size_gb                 = 60
  prefix                          = random_id.prefix.hex
  resource_group_name             = var.resource_group_name
  rbac_aad                        = false
  sku_tier                        = "Standard"
}
