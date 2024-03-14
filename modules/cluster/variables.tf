variable "resource_group" {
  description = "The resource group in which to create all resources."
  type = object({
    name     = string
    location = string
    id       = string
  })
  nullable = false
}

variable "infix" {
  description = "The infix to use for naming all resources."
  type        = string
  nullable    = false
}

variable "name" {
  description = "The name of the scope for all resources."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "The tags to associate with all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

################################################################################

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the cluster."
  type        = string
  nullable    = false
}

variable "subnet_ids" {
  description = "The ids of the subnets to use for the cluster."
  type        = map(string)
  nullable    = false
}

variable "api_server_authorized_ip_ranges" {
  description = "The authorized IP ranges for the cluster API server."
  type        = list(string)
  default     = null
  nullable    = true
}

variable "azure_container_registry_id" {
  description = "The id of the container registry to link to the cluster."
  type        = string
  nullable    = false
}
