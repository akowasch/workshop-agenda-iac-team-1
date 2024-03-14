output "ids" {
  description = "The ids of the nat gateways."
  value       = { for k, v in azurerm_nat_gateway.this : k => v.id }
}

output "public_ip_addresses" {
  description = "The public ip addresses of the nat gateways."
  value       = [for v in azurerm_public_ip.this : v.ip_address]
}
