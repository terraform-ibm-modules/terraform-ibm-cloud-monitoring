########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

variable "region" {
  description = "The IBM Cloud region where Cloud monitoring instance will be created."
  type        = string
  default     = "us-south"
}

########################################################################################################################
# IBM Cloud Metrics Routing
########################################################################################################################

variable "default_targets" {
  description = "Where metrics that are not explicitly managed in the account's routing rules are routed. Consider defining a second default target when you want to collect the data in a backup location."
  type = list(object({
    id = string
  }))
  default = []
}

variable "primary_metadata_region" {
  description = "The location in your IBM Cloud account where the IBM Cloud Metrics Routing account configuration metadata is stored. To store all your meta data in a single region. For new accounts, all target / route creation will fail until primary_metadata_region is set."
  type        = string
  default     = null
}

variable "backup_metadata_region" {
  description = "You can also configure a backup location where the metadata is stored for recovery purposes."
  type        = string
  default     = null
}

variable "permitted_target_regions" {
  description = "Control where targets collecting platform metrics can be located."
  type        = list(string)
  default     = []
}

variable "private_api_endpoint_only" {
  description = "The type of endpoints that are allowed to manage the IBM Cloud Metrics Routing account configuration in the account. By default, public and private endpoints are enabled."
  type        = bool
  default     = false
}
