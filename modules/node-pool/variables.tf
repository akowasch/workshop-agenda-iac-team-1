variable "resource_group" {
  description = "The resource group in which to create all resources."
  type = object({
    name     = string
    location = string
    id       = string
  })
  nullable = false
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

variable "os_type" {
  description = "The operating system type for the node pool."
  type        = string
  nullable    = false
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in GB."
  type        = number
  nullable    = false
}

variable "cluster_id" {
  description = "The cluster id for which node pools should be created."
  type        = string
  nullable    = false
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the cluster."
  type        = string
  nullable    = false
}

variable "vm_size" {
  description = "The size of the virtual machines to use for the node pool."
  type        = string
  nullable    = false
}

variable "subnet_ids" {
  description = "The ids of the subnets to use for the node pool."
  type        = map(string)
  nullable    = false
}

variable "node_labels" {
  description = "Any labels to be set on the nodes."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "node_taints" {
  description = "Any taints to be set on the nodes."
  type        = map(string)
  nullable    = false
}

variable "min_count" {
  description = "The minimum number of nodes for the node pool."
  type        = number
  nullable    = false
}

variable "max_count" {
  description = "The maximum number of nodes for the node pool."
  type        = number
  nullable    = false
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each node."
  type        = number
  nullable    = false
}

variable "priority" {
  description = "The priority for virtual machines of the node pool."
  type        = string
  nullable    = false
}
