########################################################################
# IBM Cloud Metric Routing
#########################################################################

# metric routing to cloud monitoring s2s auth policy
resource "ibm_iam_authorization_policy" "metrics_router_cloud_monitoring" {
  for_each                    = { for target in var.metrics_router_targets : target.target_name => target if !target.skip_metrics_router_auth_policy }
  source_service_name         = "metrics-router"
  target_service_name         = "sysdig-monitor"
  target_resource_instance_id = regex(".*:(.*)::", each.value.destination_crn)[0]
  roles                       = ["Supertenant Metrics Publisher"]
  description                 = "Permit metrics routing service Supertenant Metrics Publisher access to Cloud Monitoring instance ${each.value.destination_crn}"
}

resource "time_sleep" "wait_for_cloud_monitoring_auth_policy" {
  depends_on      = [ibm_iam_authorization_policy.metrics_router_cloud_monitoring]
  create_duration = "30s"
}


########################################################################
# IBM Cloud Metric Routing
#########################################################################

resource "ibm_metrics_router_target" "metrics_router_targets" {
  depends_on      = [time_sleep.wait_for_cloud_monitoring_auth_policy]
  for_each        = { for target in var.metrics_router_targets : target.target_name => target }
  destination_crn = each.value.destination_crn
  name            = each.key
  region          = each.value.target_region
}

########################################################################
# Metrics Routing Routes
#########################################################################

resource "ibm_metrics_router_route" "metrics_router_routes" {
  for_each = { for route in var.metrics_router_routes : route.name => route }
  name     = each.key
  dynamic "rules" {
    for_each = each.value.rules
    content {
      action = rules.value.action
      dynamic "targets" {
        for_each = length(rules.value.targets) > 0 ? rules.value.targets : []
        content {
          id = targets.value.id
        }
      }
      dynamic "inclusion_filters" {
        for_each = rules.value.inclusion_filters
        content {
          operand  = inclusion_filters.value.operand
          operator = inclusion_filters.value.operator
          values   = inclusion_filters.value.values
        }
      }
    }
  }
  # The create_before_destroy meta-argument makes sure that the routes are created first before the prior ones are destroyed.
  lifecycle {
    create_before_destroy = true
  }
}


########################################################################
# Global Metrics Routing Settings
#########################################################################

resource "ibm_metrics_router_settings" "metrics_router_settings" {
  count = length(var.metrics_router_settings == null ? [] : [1])
  dynamic "default_targets" {
    for_each = var.metrics_router_settings.default_targets
    content {
      id = default_targets.value
    }
  }
  permitted_target_regions  = var.metrics_router_settings.permitted_target_regions
  primary_metadata_region   = var.metrics_router_settings.primary_metadata_region
  backup_metadata_region    = var.metrics_router_settings.backup_metadata_region
  private_api_endpoint_only = var.metrics_router_settings.private_api_endpoint_only

  # The create_before_destroy meta-argument makes sure that the new settings are applied first before the prior ones are removed.
  lifecycle {
    create_before_destroy = true
  }
}
