#######################################################################################################################
# Resource Group
#######################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.4.0"
  existing_resource_group_name = var.existing_resource_group_name
}

#######################################################################################################################
# Cloud Monitoring CRN Parser
#######################################################################################################################

module "existing_cloud_monitoring_crn_parser" {
  count   = var.existing_cloud_monitoring_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.2.0"
  crn     = var.existing_cloud_monitoring_crn
}

#######################################################################################################################
# IBM Cloud Monitoring
#######################################################################################################################

locals {
  prefix                         = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""
  create_cloud_monitoring        = var.existing_cloud_monitoring_crn == null
  cloud_monitoring_crn           = local.create_cloud_monitoring ? module.cloud_monitoring[0].crn : var.existing_cloud_monitoring_crn
  cloud_monitoring_instance_name = "${local.prefix}${var.cloud_monitoring_instance_name}"
  metrics_router_target_name     = "${local.prefix}${var.metrics_routing_target_name}"
  metrics_router_route_name      = "${local.prefix}${var.metrics_routing_route_name}"

  default_metrics_router_route = var.enable_metrics_routing_to_cloud_monitoring ? [{
    name = local.metrics_router_route_name
    rules = [{
      action = "send"
      targets = [{
        id = module.metrics_routing[0].metrics_router_targets[local.metrics_router_target_name].id
      }]
      inclusion_filters = []
    }]
  }] : []
}

module "cloud_monitoring" {
  count                   = local.create_cloud_monitoring ? 1 : 0
  source                  = "../.."
  resource_group_id       = module.resource_group.resource_group_id
  region                  = var.region
  instance_name           = local.cloud_monitoring_instance_name
  plan                    = var.cloud_monitoring_plan
  resource_tags           = var.cloud_monitoring_resource_tags
  access_tags             = var.cloud_monitoring_access_tags
  resource_keys           = var.cloud_monitoring_resource_keys
  service_endpoints       = "public-and-private"
  enable_platform_metrics = var.enable_platform_metrics
  cbr_rules               = var.cbr_rules
}

module "metrics_routing" {
  count  = var.enable_metrics_routing_to_cloud_monitoring ? 1 : 0
  source = "../../modules/metrics_routing"
  metrics_router_targets = [
    {
      destination_crn                 = local.cloud_monitoring_crn
      target_name                     = local.metrics_router_target_name
      target_region                   = var.region
      skip_metrics_router_auth_policy = false
    }
  ]

  metrics_router_routes   = length(var.metrics_router_routes) != 0 ? var.metrics_router_routes : local.default_metrics_router_route
  metrics_router_settings = var.enable_primary_metadata_region ? { primary_metadata_region = var.region } : null
}
