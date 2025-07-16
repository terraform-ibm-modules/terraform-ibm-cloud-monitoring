########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key with access to configure Metrics Routing account settings."
  sensitive   = true
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

########################################################################################################################
# IBM Cloud Metrics Routing
########################################################################################################################

variable "default_targets" {
  description = "Where metrics that are not explicitly managed in the account's routing rules are routed. You can define up to 2 default targets per account. Consider defining a second default target to collect data in a backup location."
  default     = []
}

variable "primary_metadata_region" {
  description = "Storage location for target, route, and settings metadata in your IBM Cloud account. To store all configuration metadata in a single region, set this value explicitly. For new accounts, creating targets and routes will fail until `primary_metadata_region` is set. If set to `null`, no change is made to the current value."  
  type        = string
  default     = null
}

variable "backup_metadata_region" {
  description = "You can also configure a backup location where the metadata is stored for recovery purposes. The `backup_metadata_region` can't be the same as `primary_metadata_region`."
  type        = string
  default     = null
}

variable "permitted_target_regions" {
  description = "Controls where targets collecting platform metrics can be located. To allow targets in any region (i.e., No restrictions), configure this field as an empty list `[]`."
  type        = list(string)
  default     = []
}

variable "private_api_endpoint_only" {
  description = "Public endpoints can be disabled for managing IBM Cloud Metrics Routing configuration via the CLI or REST API. When public endpoints are disabled, the IBM Cloud Metrics Routing UI will be inaccessible."
  type        = bool
  default     = false
}
