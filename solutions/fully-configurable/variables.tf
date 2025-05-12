########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision resources to. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "Default"
}

variable "prefix" {
  type        = string
  description = "The prefix to add to all resources that this solution creates. Prefix must begin with a lowercase letter, contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters. It also cannot have a `--`. To not use any prefix value, you can set this value to `null` or an empty string."
  nullable    = true
  validation {
    condition = (var.prefix == null ? true :
      alltrue([
        can(regex("^[a-z]{0,1}[-a-z0-9]{0,14}[a-z0-9]{0,1}$", var.prefix)),
        length(regexall("^.*--.*", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter, contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters."
  }
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
# Cloud Monitoring
########################################################################################################################

variable "existing_cloud_monitoring_crn" {
  type        = string
  default     = null
  description = "The CRN of an existing Cloud Monitoring instance. If not supplied, a new instance will be created."
}

variable "cloud_monitoring_instance_name" {
  type        = string
  description = "The name of the IBM Cloud Monitoring instance to create. If the prefix variable is passed, the name of the instance is prefixed to the value in the `<prefix>-value` format."
  default     = "cloud-monitoring"
}

variable "cloud_monitoring_resource_tags" {
  type        = list(string)
  description = "Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings)."
  default     = []
}

variable "cloud_monitoring_access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the IBM Cloud Monitoring instance created by the DA. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []
}

variable "cloud_monitoring_plan" {
  type        = string
  description = "The IBM Cloud Monitoring plan to provision. Available values are `lite` and `graduated-tier`."
  default     = "graduated-tier"

  validation {
    condition     = can(regex("^lite$|^graduated-tier$", var.cloud_monitoring_plan))
    error_message = "Specify one of the following values for the `cloud_monitoring_plan`: `lite` or `graduated-tier`."
  }
}

variable "enable_platform_metrics" {
  type        = bool
  description = "When set to `true`, the IBM Cloud Monitoring instance collects the platform metrics."
  default     = false
}

########################################################################################################################
# Metrics Routing
########################################################################################################################

variable "metrics_routing_target_name" {
  type        = string
  description = "The name of the IBM Cloud Metrics Routing target where metrics are collected. If the prefix variable is passed, the name of the target is prefixed to the value in the `<prefix>-value` format."
  default     = "cloud-monitoring-target"
}

variable "metrics_routing_route_name" {
  type        = string
  description = "The name of the IBM Cloud Metrics Routing route for the default route that indicate what metrics are routed in a region and where to store them. If the prefix variable is passed, the name of the target is prefixed to the value in the `<prefix>-value` format."
  default     = "metrics-routing-route"
}

variable "enable_metrics_routing_to_cloud_monitoring" {
  type        = bool
  description = "Whether to enable metrics routing from IBM Cloud Metric Routing to Cloud Monitoring."
  default     = true
}

variable "metrics_router_routes" {
  type = list(object({
    name = string
    rules = list(object({
      action = string
      targets = list(object({
        id = string
      }))
      inclusion_filters = list(object({
        operand  = string
        operator = string
        values   = list(string)
      }))
    }))
  }))
  default     = []
  description = "Routes for IBM Cloud Metrics Routing. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-observability-da/blob/main/solutions/instances/DA-types.md#metrics-router-routes-)"
}

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
  description = "The list of context-based restriction rules to create for the instance. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-cloud-monitoring/blob/main/solutions/fully-configurable/DA-types.md)"
  default     = []
  # Validation happens in the rule module
}
