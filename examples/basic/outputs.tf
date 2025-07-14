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

output "ingestion_endpoint_private" {
  value       = module.cloud_monitoring.ingestion_endpoint_private
  description = "The Cloud Monitoring private ingestion endpoint."
}

output "ingestion_endpoint_public" {
  value       = module.cloud_monitoring.ingestion_endpoint_public
  description = "The Cloud Monitoring public ingestion endpoint."
}
