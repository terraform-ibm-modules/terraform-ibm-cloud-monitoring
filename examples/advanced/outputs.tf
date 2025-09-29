##############################################################################
# Outputs
##############################################################################

#
# Developer tips:
#   - Include all relevant outputs from the modules being called in the example
#

output "cloud_monitoring_crn" {
  value       = module.cloud_monitoring.crn
  description = "The CRN of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_guid" {
  value       = module.cloud_monitoring.guid
  description = "The GUID of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_name" {
  value       = module.cloud_monitoring.name
  description = "The name of the provisioned IBM cloud monitoring instance."
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The resource group where cloud monitoring monitor instance resides."
}

output "cloud_monitoring_resource_keys" {
  value       = module.cloud_monitoring.resource_keys
  description = "IBM Cloud Monitoring resource keys for agents to use"
  sensitive   = true
}

output "metrics_router_routes" {
  value       = module.metrics_routing.metrics_router_routes
  description = "The created metrics routing routes."
}

output "metrics_router_targets" {
  value       = module.metrics_routing.metrics_router_targets
  description = "The created metrics routing targets."
}

output "metrics_router_settings" {
  value       = module.metrics_routing.metrics_router_settings
  description = "The global metrics routing settings."
}
