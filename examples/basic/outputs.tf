##############################################################################
# Outputs
##############################################################################

output "cloud_monitoring_crn" {
  value       = module.cloud_monitoring.crn
  description = "The CRN of the provisioned IBM cloud monitoring instance."
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
  description = "The map of resource keys created for the Cloud Monitoring instance."
  sensitive   = true
}

output "cloud_monitoring_access_key" {
  value       = module.cloud_monitoring.access_keys["SysdigManagerKey"]
  description = "The Cloud Monitoring access keys for agents to use."
  sensitive   = true
}

output "ingestion_endpoint_private" {
  value       = module.cloud_monitoring.ingestion_endpoint_private
  description = "The Cloud Monitoring private ingestion endpoint."
}

output "ingestion_endpoint_public" {
  value       = module.cloud_monitoring.ingestion_endpoint_public
  description = "The Cloud Monitoring public ingestion endpoint."
}
