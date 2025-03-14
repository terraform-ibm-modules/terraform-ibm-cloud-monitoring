##############################################################################
# Local Variables
##############################################################################

locals {
  instance_name = var.instance_name != null ? var.instance_name : "cloud-monitoring-${var.region}"
}

##############################################################################
# Cloud Monitoring
##############################################################################

resource "ibm_resource_instance" "cloud_monitoring" {
  name              = local.instance_name
  resource_group_id = var.resource_group_id
  service           = "sysdig-monitor"
  plan              = var.plan
  location          = var.region
  tags              = var.tags
  service_endpoints = var.service_endpoints

  parameters = {
    "default_receiver" = var.enable_platform_metrics
  }
}

resource "ibm_resource_tag" "cloud_monitoring_tag" {
  count       = length(var.access_tags) == 0 ? 0 : 1
  resource_id = ibm_resource_instance.cloud_monitoring.crn
  tags        = var.access_tags
  tag_type    = "access"
}

resource "ibm_resource_key" "resource_key" {
  name                 = var.manager_key_name
  resource_instance_id = ibm_resource_instance.cloud_monitoring.id
  role                 = "Manager"
  tags                 = var.manager_key_tags
}

resource "time_sleep" "wait_for_cloud_monitoring_instance" {
  depends_on      = [ibm_resource_instance.cloud_monitoring]
  create_duration = "30s"
}

########################################################################
# IBM Cloud Metric Routing
#########################################################################

resource "ibm_iam_authorization_policy" "cloud_monitoring_policy" {
  depends_on                  = [time_sleep.wait_for_cloud_monitoring_instance]
  for_each                    = { for target in var.metrics_router_targets : target.target_name => target if !target.skip_mrouter_sysdig_iam_auth_policy }
  source_service_name         = "metrics-router"
  target_service_name         = "sysdig-monitor"
  target_resource_instance_id = regex(".*:(.*)::", each.value.destination_crn)[0]
  roles                       = ["Supertenant Metrics Publisher"]
  description                 = "Permit metrics routing service Supertenant Metrics Publisher access to Cloud Monitoring instance ${each.value.destination_crn}"
}

resource "time_sleep" "wait_for_cloud_monitoring_auth_policy" {
  depends_on      = [ibm_iam_authorization_policy.cloud_monitoring_policy]
  create_duration = "30s"
}

########################################################################
# Metrics Routing Targets
#########################################################################

resource "ibm_metrics_router_target" "metrics_router_targets" {
  depends_on      = [time_sleep.wait_for_cloud_monitoring_instance]
  for_each        = { for target in var.metrics_router_targets : target.target_name => target }
  destination_crn = each.value.destination_crn
  name            = each.key
  region          = each.value.target_region
}

########################################################################
# Metrics Routing Routes
#########################################################################

resource "ibm_metrics_router_route" "metrics_router_routes" {
  depends_on = [ibm_metrics_router_target.metrics_router_targets]
  for_each   = { for route in var.metrics_router_routes : route.name => route }
  name       = each.key
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
}

########################################################################
# Global Metrics Routing Settings
#########################################################################

resource "ibm_metrics_router_settings" "metrics_router_settings" {
  depends_on = [ibm_metrics_router_target.metrics_router_targets]
  count      = length(var.metrics_router_settings == null ? [] : [1])
  dynamic "default_targets" {
    for_each = var.metrics_router_settings.default_targets
    content {
      id = default_targets.value.id
    }
  }
  permitted_target_regions  = var.metrics_router_settings.permitted_target_regions
  primary_metadata_region   = var.metrics_router_settings.primary_metadata_region
  backup_metadata_region    = var.metrics_router_settings.backup_metadata_region
  private_api_endpoint_only = var.metrics_router_settings.private_api_endpoint_only

  lifecycle {
    create_before_destroy = true
  }
}
