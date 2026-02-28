##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.4.8"
  resource_group_name = "${var.prefix}-resource-group"
}

##############################################################################
# IBM Cloud Monitoring instance
##############################################################################

module "cloud_monitoring" {
  source            = "terraform-ibm-modules/cloud-monitoring/ibm"
  version           = "1.14.2"
  region            = var.region
  resource_group_id = module.resource_group.resource_group_id
  resource_tags     = var.resource_tags
}
