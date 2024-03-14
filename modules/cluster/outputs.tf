output "id" {
  description = "The id of the kubernetes cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "kube_config" {
  description = "The kube_config of the kubernetes cluster."
  value       = azurerm_kubernetes_cluster.this.kube_admin_config[0]
  sensitive   = true
}
