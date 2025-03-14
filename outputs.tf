output "crn" {
  value       = length(ibm_resource_instance.cloud_monitoring) > 0 ? ibm_resource_instance.cloud_monitoring.id : null
  description = "The id of the provisioned cloud monitoring instance."
}

output "guid" {
  value       = length(ibm_resource_instance.cloud_monitoring) > 0 ? ibm_resource_instance.cloud_monitoring.guid : null
  description = "The guid of the provisioned cloud monitoring instance."
}

output "name" {
  value       = length(ibm_resource_instance.cloud_monitoring) > 0 ? ibm_resource_instance.cloud_monitoring.name : null
  description = "The name of the provisioned cloud monitoring instance."
}

output "resource_group_id" {
  value       = length(ibm_resource_instance.cloud_monitoring) > 0 ? ibm_resource_instance.cloud_monitoring.resource_group_id : null
  description = "The resource group where cloud monitoring monitor instance resides"
}

output "access_key" {
  value       = length(ibm_resource_key.resource_key) > 0 ? ibm_resource_key.resource_key.credentials["Sysdig Access Key"] : null
  description = "The cloud monitoring access key for agents to use"
  sensitive   = true
}

output "manager_key_name" {
  value       = length(ibm_resource_key.resource_key) > 0 ? ibm_resource_key.resource_key.name : null
  description = "The cloud monitoring manager key name"
}

########################################################################
# Metrics Routing
#########################################################################

# Metric Routing Target

# output "metrics_router_targets" {
#   value       = ibm_metrics_router_target.metrics_router_targets
#   description = "The created metrics routing targets."
# }
# 
# # Metric Routing Routes
# 
# output "metrics_router_routes" {
#   value       = ibm_metrics_router_route.metrics_router_routes
#   description = "The created metrics routing routes."
# }
# 
# # Metric Routing Global Settings
# 
# output "metrics_router_settings" {
#   value       = ibm_metrics_router_settings.metrics_router_settings
#   description = "The global metrics routing settings."
# }
