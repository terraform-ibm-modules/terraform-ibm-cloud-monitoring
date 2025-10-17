##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Cloud Monitoring
##############################################################################

module "cloud_monitoring" {
  source            = "../../"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  resource_tags     = var.resource_tags
  instance_name     = "${var.prefix}-cloud-monitoring"
  plan              = "graduated-tier"
}
