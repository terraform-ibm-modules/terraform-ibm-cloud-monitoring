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
  description = "Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings)."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Access Management Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings)."
  default     = []
}
