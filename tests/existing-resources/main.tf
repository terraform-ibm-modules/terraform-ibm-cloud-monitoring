##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.2.0"
  resource_group_name = "${var.prefix}-resource-group"
}

##############################################################################
# Resource Group 1
##############################################################################

module "cloud_monitoring" {
  source            = "terraform-ibm-modules/cloud-monitoring/ibm"
  version           = "1.2.12"
  region            = var.region
  resource_group_id = module.resource_group.resource_group_id
  resource_tags     = var.resource_tags
}
