################################################################################
# Locals

locals {
  availability_zones = toset(["1", "2", "3"])

  tags = merge(var.tags, {
    Module = "devops-platform/gitlab/runner/azure-runner/iac/modules/subnet"
  })
}

################################################################################
# Subnets

resource "azurerm_subnet" "this" {
  for_each = local.availability_zones

  name                 = "${var.name}-z${each.value}"
  resource_group_name  = var.resource_group.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.address_prefixes[each.value]]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.ContainerRegistry",
  ]
}

################################################################################
# Subnet NAT Gateway Associations

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = local.availability_zones

  subnet_id      = azurerm_subnet.this[each.value].id
  nat_gateway_id = var.nat_gateway_ids[each.value]
}

################################################################################
# Subnet Network Security Group Associations

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.availability_zones

  subnet_id                 = azurerm_subnet.this[each.value].id
  network_security_group_id = var.network_security_group_id
}

################################################################################
# Subnet Route Table Associations

resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.availability_zones

  subnet_id      = azurerm_subnet.this[each.value].id
  route_table_id = var.route_table_id
}
