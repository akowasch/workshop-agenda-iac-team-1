################################################################################
# Locals

locals {
  availability_zones = toset(["1", "2", "3"])
  public_ips         = range(1, var.public_ip_count + 1)
  availability_zones_public_ips = {
    for e in setproduct(local.availability_zones, local.public_ips) : "z${e.0}-ip${e.1}" => {
      zone = e.0
      ip   = tostring(e.1)
    }
  }

  tags = merge(var.tags, {
    Module = "devops-platform/gitlab/runner/azure-runner/iac/modules/nat-gateway"
  })
}

################################################################################
# NAT Gateways

resource "azurerm_nat_gateway" "this" {
  for_each = local.availability_zones

  name                    = "natgw-${var.infix}-${var.name}-z${each.value}"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [each.value]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

################################################################################
# Public IPs

resource "azurerm_public_ip" "this" {
  for_each = local.availability_zones_public_ips

  name                = "pip-${var.infix}-${var.name}-z${each.value.zone}-${format("%02s", each.value.ip)}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [each.value.zone]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

################################################################################
# NAT Gateway Public IP Associations

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = local.availability_zones_public_ips

  nat_gateway_id       = azurerm_nat_gateway.this[each.value.zone].id
  public_ip_address_id = azurerm_public_ip.this[each.key].id
}
