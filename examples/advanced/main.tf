##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.7"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# CBR zone
##############################################################################

module "cbr_schematics_zone" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.35.4"
  name             = "${var.prefix}-schematics-network-zone"
  zone_description = "CBR Network zone containing Schematics"
  account_id       = module.cloud_monitoring.account_id
  addresses = [{
    type = "serviceRef"
    ref = {
      account_id   = module.cloud_monitoring.account_id
      service_name = "schematics"
    }
  }]
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
  cbr_rules = [{
    description      = "${var.prefix}-cloud-monitoring access from schematics zone"
    account_id       = module.cloud_monitoring.account_id
    enforcement_mode = "report"
    rule_contexts = [{
      attributes = [
        {
          "name" : "endpointType",
          "value" : "private"
        },
        {
          name  = "networkZoneId"
          value = module.cbr_schematics_zone.zone_id
        }
      ]
    }]
  }]
}

##############################################################################
# IBM Cloud Metrics Routing
#   - Cloud Monitoring target
#   - Metrics Router route to the cloud monitoring target
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

  /*

  ##############################################################################
  # - Global Metrics Routing configuration
  ##############################################################################

  Uncomment below to set metrics router settings. A `primary_metadata_region` is required to be set before metrics routing can be configured.

  metrics_router_settings = {
    default_targets = [{
      id = module.metrics_routing.metrics_router_targets[local.metrics_router_target_name].id
    }]
    permitted_target_regions  = ["us-south", "eu-de", "us-east", "eu-es", "eu-gb", "au-syd", "br-sao", "ca-tor", "jp-tok", "jp-osa"]
    primary_metadata_region   = var.region
    private_api_endpoint_only = false
  }
  */
}
