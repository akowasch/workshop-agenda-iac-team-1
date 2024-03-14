output "ids" {
  description = "The ids of the subnets."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}
