variable "region" {
  type        = string
  description = "The IBM Cloud region where Cloud Monitoring instance will be created."
  default     = "us-south"
}

variable "resource_group_id" {
  type        = string
  description = "The id of the IBM Cloud resource group where the Cloud Monitoring instance will be created."
}

variable "instance_name" {
  type        = string
  description = "The name of the IBM Cloud Monitoring instance to create. Defaults to 'cloud-monitoring-<region>'"
  default     = null
}

variable "plan" {
  type        = string
  description = "The IBM Cloud Monitoring plan to provision. Available: lite, graduated-tier and graduated-tier-sysdig-secure-plus-monitor (available in region eu-fr2 only)"
  default     = "lite"

  validation {
    condition     = can(regex("^lite$|^graduated-tier$|^graduated-tier-sysdig-secure-plus-monitor$", var.plan))
    error_message = "The plan value must be one of the following: lite, graduated-tier and graduated-tier-sysdig-secure-plus-monitor (available in region eu-fr2 only)."
  }

  validation {
    condition     = (var.plan != "graduated-tier-sysdig-secure-plus-monitor") || var.region == "eu-fr2"
    error_message = "When plan is graduated-tier-sysdig-secure-plus-monitor region should be set to eu-fr2."
  }
}

variable "disable_access_key_creation" {
  type        = bool
  description = "When set to true, disables the creation of a default manager access key which is required by agents to ingest metrics."
  default     = false
}

variable "access_key_name" {
  type        = string
  description = "The name to give the default IBM Cloud Monitoring Manager access key. Use `disable_access_key_creation` to disable access key creation. For guidance on access keys, see [here](https://cloud.ibm.com/docs/monitoring?topic=monitoring-access_key)."
  default     = "SysdigManagerKey"
}

variable "access_key_tags" {
  type        = list(string)
  description = "Tags associated with the IBM Cloud Monitoring access key."
  default     = []
}

# 'name' is the terraform static reference to the object in the list
# 'key_name' is the IBM Cloud resource key name
# name MUST not be dynamic, so that it is known at plan time
# if key_name is not specified, name will be used for the key_name
# key_name can be a dynamic reference created during apply
variable "resource_keys" {
  description = "A list of maps representing resource keys to create for the IBM Cloud Monitoring instance. Each entry defines a single resource key. Use this list to manage custom keys and handle key rotation."
  type = list(object({
    name                      = string
    key_name                  = optional(string, null)
    generate_hmac_credentials = optional(bool, false) # pragma: allowlist secret
    role                      = optional(string, "Manager")
    service_id_crn            = optional(string, null)
  }))
  default = []
  validation {
    # From: https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key
    # Service roles (for Cloud Monitoring) https://cloud.ibm.com/iam/roles
    # Reader, Writer, Manager, Supertenant Metrics Publisher, NONE
    condition = alltrue([
      for key in var.resource_keys : contains(["Writer", "Reader", "Manager", "Supertenant Metrics Publisher", "NONE"], key.role)
    ])
    error_message = "resource_keys role must be one of 'Writer', 'Reader', 'Manager', 'Supertenant Metrics Publisher', 'NONE', reference https://cloud.ibm.com/iam/roles and `Cloud Monitoring`"
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Add user resource tags to the Cloud Monitoring instance to organize, track, and manage costs. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)"
  default     = []

  validation {
    condition     = alltrue([for tag in var.resource_tags : can(regex("^[A-Za-z0-9 _\\-.:]{1,128}$", tag))])
    error_message = "Each resource tag must be 128 characters or less and may contain only A-Z, a-z, 0-9, spaces, underscore (_), hyphen (-), period (.), and colon (:)."
  }
}

variable "access_tags" {
  type        = list(string)
  description = "Add access management tags to the Cloud Monitoring instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#create-access-console)"
  default     = []
}

variable "enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in the provisioned IBM Cloud Monitoring instance. Only 1 instance in a given region can be enabled for platform metrics."
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

##############################################################
# Context-based restriction (CBR)
##############################################################

variable "cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
    operations = optional(list(object({
      api_types = list(object({
        api_type_id = string
      }))
    })))
  }))
  description = "The context-based restrictions rule to create. Only one rule is allowed."
  default     = []
  # Validation happens in the rule module
  validation {
    condition     = length(var.cbr_rules) <= 1
    error_message = "Only one CBR rule is allowed."
  }
}
