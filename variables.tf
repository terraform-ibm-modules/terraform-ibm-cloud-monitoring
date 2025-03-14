variable "region" {
  type        = string
  description = "The IBM Cloud region where instances will be created."
  default     = "us-south"
}

variable "resource_group_id" {
  type        = string
  description = "The id of the IBM Cloud resource group where the instance(s) will be created."
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

variable "tags" {
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


variable "metrics_router_targets" {
  type = list(object({
    destination_crn                     = string
    target_name                         = string
    target_region                       = optional(string)
    skip_mrouter_sysdig_iam_auth_policy = optional(bool, false)
  }))
  default     = []
  description = "List of Metrics Router targets to be created."
}

variable "metrics_router_routes" {
  type = list(object({
    name = string
    rules = list(object({
      action = optional(string, "send")
      targets = optional(list(object({
        id = string
      })))
      inclusion_filters = list(object({
        operand  = string
        operator = string
        values   = list(string)
      }))
    }))
  }))
  default     = []
  description = "List of routes for IBM Metrics Router"

  validation {
    condition = length(var.metrics_router_routes) == 0 || alltrue([
      for route in var.metrics_router_routes : alltrue([
        for rule in route.rules : length(rule.inclusion_filters) <= 5
      ])
    ])
    error_message = "The 'metrics_router_routes' list can be empty or contain routes with rules, and each rule's 'inclusion_filters' must have less than 5 items."
  }
  validation {
    condition = length(var.metrics_router_routes) == 0 || alltrue([
      for route in var.metrics_router_routes : alltrue([
        for rule in route.rules :
        rule.action != "send" || length(rule.targets) > 0
      ])
    ])
    error_message = "Each rule with action 'send' must have at least one target defined in 'targets'."
  }
}

variable "metrics_router_settings" {
  type = object({
    permitted_target_regions  = optional(list(string))
    primary_metadata_region   = optional(string)
    backup_metadata_region    = optional(string)
    private_api_endpoint_only = optional(bool, false)
    default_targets = optional(list(object({
      id = string
    })))
  })
  description = "Global settings for Metrics Routing"
  default     = null

  validation {
    error_message = "Valid regions for 'permitted_target_regions' are: us-south, eu-de, us-east, eu-es, eu-gb, au-syd, br-sao, ca-tor, jp-tok, jp-osa"
    condition = (var.metrics_router_settings == null ?
      true :
      alltrue([
        for region in var.metrics_router_settings.permitted_target_regions :
        contains(["jp-osa", "au-syd", "jp-tok", "eu-de", "eu-gb", "eu-es", "us-south", "ca-tor", "us-east", "br-sao"], region)
      ])
    )
  }
}
