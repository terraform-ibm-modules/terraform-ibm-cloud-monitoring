##############################################################################
# Outputs
##############################################################################

#
# Developer tips:
#   - Include all relevant outputs from the modules being called in the example
#

output "cloud_monitoring_crn" {
  value       = module.cloud_monitoring_adv.crn
  description = "The CRN of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_guid" {
  value       = module.cloud_monitoring_adv.guid
  description = "The GUID of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_name" {
  value       = module.cloud_monitoring_adv.name
  description = "The name of the provisioned IBM cloud monitoring instance."
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The resource group where cloud monitoring monitor instance resides."
}

output "access_key" {
  value       = module.cloud_monitoring_adv.access_key
  description = "The cloud monitoring access key for agents to use."
  sensitive   = true
}

output "manager_key_name" {
  value       = module.cloud_monitoring_adv.manager_key_name
  description = "The cloud monitoring manager key name."
}

output "metrics_router_routes" {
  value       = module.cloud_monitoring_adv.metrics_router_routes
  description = "The created metrics routing routes."
}

output "metrics_router_targets" {
  value       = module.cloud_monitoring_adv.metrics_router_targets
  description = "The created metrics routing targets."
}

output "metrics_router_settings" {
  value       = module.cloud_monitoring_adv.metrics_router_settings
  description = "The global metrics routing settings."
}
