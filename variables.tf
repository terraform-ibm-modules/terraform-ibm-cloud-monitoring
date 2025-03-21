variable "region" {
  type        = string
  description = "The IBM Cloud region where Cloud Monitoring instance will be created."
  default     = "us-south"
}

variable "resource_group_id" {
  type        = string
  description = "The id of the IBM Cloud resource group where the Cloud Monitoring instance will be created."
}

variable "cloud_monitoring_provision" {
  description = "Provision a IBM cloud monitoring instance?"
  type        = bool
  default     = true
}

variable "instance_name" {
  type        = string
  description = "The name of the IBM Cloud Monitoring instance to create. Defaults to 'cloud-monitoring-<region>'"
  default     = null
}

variable "plan" {
  type        = string
  description = "The IBM Cloud Monitoring plan to provision. Available: lite, graduated-tier"
  default     = "lite"

  validation {
    condition     = can(regex("^lite$|^graduated-tier$", var.plan))
    error_message = "The plan value must be one of the following: lite, graduated-tier."
  }
}

variable "manager_key_name" {
  type        = string
  description = "The name to give the IBM Cloud Monitoring manager key."
  default     = "SysdigManagerKey"
}

variable "manager_key_tags" {
  type        = list(string)
  description = "Tags associated with the IBM Cloud Monitoring manager key."
  default     = []
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

variable "enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in the provisioned IBM Cloud Monitoring instance."
  default     = false
}

variable "service_endpoints" {
  description = "The type of the service endpoint that will be set for the Sisdig instance."
  type        = string
  default     = "public-and-private"
  validation {
    condition     = contains(["public-and-private"], var.service_endpoints)
    error_message = "The specified service_endpoints is not a valid selection"
  }
}
