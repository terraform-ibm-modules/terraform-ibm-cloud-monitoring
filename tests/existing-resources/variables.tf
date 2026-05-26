##############################################################################
# Input variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of resource tags to associate with all resource instances created by this example."
  default     = []
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable."
  default     = null
}