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

variable "public_ip_count" {
  description = "The number of public ip addressses to associate with the nat gateway."
  type        = number
  nullable    = false
}
