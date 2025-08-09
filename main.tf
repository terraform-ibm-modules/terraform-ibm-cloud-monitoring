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
  tags              = var.resource_tags
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

########################################################################
# Context Based Restrictions
#########################################################################

locals {
  default_operations = [{
    api_types = [
      {
        "api_type_id" : "crn:v1:bluemix:public:context-based-restrictions::::api-type:"
      }
    ]
  }]
}

module "cbr_rule" {
  count            = length(var.cbr_rules)
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-rule-module"
  version          = "1.32.7"
  rule_description = var.cbr_rules[count.index].description
  enforcement_mode = var.cbr_rules[count.index].enforcement_mode
  rule_contexts    = var.cbr_rules[count.index].rule_contexts
  resources = [{
    attributes = [
      {
        name  = "accountId"
        value = var.cbr_rules[count.index].account_id
      },
      {
        name  = "serviceName"
        value = "sysdig-monitor"
      },
      {
        name     = "serviceInstance"
        value    = ibm_resource_instance.cloud_monitoring.guid
        operator = "stringEquals"
      }
    ]
  }]
  operations = var.cbr_rules[count.index].operations == null ? local.default_operations : var.cbr_rules[count.index].operations
}
