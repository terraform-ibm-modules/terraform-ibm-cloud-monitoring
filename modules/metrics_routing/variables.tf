variable "metrics_router_targets" {
  type = list(object({
    destination_crn                 = string
    target_name                     = string
    target_region                   = optional(string)
    skip_metrics_router_auth_policy = optional(bool, false)
  }))
  default     = []
  nullable    = false
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
  nullable    = false
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
    permitted_target_regions  = optional(list(string), [])
    primary_metadata_region   = optional(string)
    backup_metadata_region    = optional(string)
    private_api_endpoint_only = optional(bool, false)
    default_targets           = optional(list(string), [])
  })
  description = "The global account settings for Metrics Routing. To configure metrics routing, the account must have a `primary_metadata_region` set. You will be unable to view the account settings in the UI if `private_api_endpoint_only` is set to true. For more information, see https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-settings-about&interface=ui."
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
