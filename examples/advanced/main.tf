##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Cloud Monitoring
##############################################################################

locals {
  cloud_monitoring_instance_name = "${var.prefix}-cloud-monitoring"
  metrics_router_target_name     = "${var.prefix}-cloud-monitoring-target"
}

module "cloud_monitoring" {
  source            = "../../"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  resource_tags     = var.resource_tags
  access_tags       = var.access_tags
  plan              = "graduated-tier"
  instance_name     = local.cloud_monitoring_instance_name
}

##############################################################################
# IBM Cloud Metrics Routing
#   - Cloud Monitoring target
#   - Metrics Router route to the target
##############################################################################

module "metrics_routing" {
  source = "../../modules/metrics_routing"

  metrics_router_targets = [
    {
      destination_crn = module.cloud_monitoring.crn
      target_name     = local.metrics_router_target_name
      target_region   = var.region
    }
  ]

  metrics_router_routes = [
    {
      name = "${var.prefix}-metric-routing-route"
      rules = [
        {
          action = "send"
          targets = [{
            id = module.metrics_routing.metrics_router_targets[local.metrics_router_target_name].id
          }]
          inclusion_filters = [{
            operand  = "location"
            operator = "is"
            values   = ["us-south"]
          }]
        }
      ]
    }
  ]

  ##############################################################################
  # - Global Metrics Routing configuration
  ##############################################################################

  metrics_router_settings = {
    default_targets = [{
      id = module.metrics_routing.metrics_router_targets[local.metrics_router_target_name].id
    }]
    permitted_target_regions  = ["us-south", "eu-de", "us-east", "eu-es", "eu-gb", "au-syd", "br-sao", "ca-tor", "jp-tok", "jp-osa"]
    primary_metadata_region   = var.region
    private_api_endpoint_only = false
  }
}
