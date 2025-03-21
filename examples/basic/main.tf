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

#
# Developer tips:
#   - Call the local module / modules in the example to show how they can be consumed
#   - include the actual module source as a code comment like below so consumers know how to consume from correct location
#

locals {
  cloud_monitoring_instance_name = "${var.prefix}-cloud-monitoring"
}

module "cloud_monitoring" {
  source            = "../../"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  resource_tags     = var.resource_tags
  instance_name     = local.cloud_monitoring_instance_name
}
