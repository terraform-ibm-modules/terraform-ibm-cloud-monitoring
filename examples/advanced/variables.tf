##############################################################################
# Variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key."
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "A string value to prefix to all resources created by this example."
  default     = "cloud-monitoring"
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable."
  default     = null
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where instances will be created."
  default     = "us-south"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of resource tags to associate with all resource instances created by this example."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to the Cloud Monitoring instance."
  default     = []
}
