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
  description = "Optional list of resource tag to associate with all resource instances created by this example."
  default     = []
}
