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

variable "vnet_name" {
  description = "The name of the virtual network in which to create the subnets."
  type        = string
  nullable    = false
}

variable "address_prefixes" {
  description = "The address prefixes to use for the subnets."
  type        = map(string)
  nullable    = false
}

variable "nat_gateway_ids" {
  description = "The ids of the nat gateways to associate with the subnets."
  type        = map(string)
  nullable    = false
}

variable "network_security_group_id" {
  description = "The id of the network security group to associate with the subnets."
  type        = string
  nullable    = false
}

variable "route_table_id" {
  description = "The id of the route table to associate with the subnets."
  type        = string
  nullable    = false
}
