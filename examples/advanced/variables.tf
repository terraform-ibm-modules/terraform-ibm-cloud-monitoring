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
  description = "Add user resource tags to the cloud-monitoring instance to organize, track, and manage costs. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)"
  validation {
    condition     = alltrue([for tag in var.resource_tags : can(regex("^[A-Za-z0-9 _\\-.:]{1,128}$", tag))])
    error_message = "Each resource tag must be 128 characters or less and may contain only A-Z, a-z, 0-9, spaces, underscore (_), hyphen (-), period (.), and colon (:)."
  }
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Add access management tags to the cloud-monitoring instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)"
  default     = []
}
