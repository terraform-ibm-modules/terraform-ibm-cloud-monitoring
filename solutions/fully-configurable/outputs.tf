##############################################################################
# Outputs
##############################################################################


output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "The name of the Resource Group the instances are provisioned in."
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The ID of the Resource Group the instances are provisioned in."
}

output "cloud_monitoring_crn" {
  value       = local.cloud_monitoring_crn
  description = "The id of the provisioned IBM cloud monitoring instance."
}
output "cloud_monitoring_name" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].name : null
  description = "The name of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_guid" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].guid : module.existing_cloud_monitoring_crn_parser[0].service_instance
  description = "The guid of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_resource_key" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].resource_keys : null
  description = "IBM cloud monitoring access key for agents to use"
  sensitive   = true
}

output "account_id" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].account_id : module.existing_cloud_monitoring_crn_parser[0].account_id
  description = "The account id where cloud monitoring instance is provisioned."
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-endpoints#endpoints_ingestion
output "ingestion_endpoint_private" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].ingestion_endpoint_private : null
  description = "The Cloud Monitoring private ingestion endpoint."
  sensitive   = true
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-endpoints#endpoints_ingestion_public
output "ingestion_endpoint_public" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].ingestion_endpoint_public : null
  description = "The Cloud Monitoring public ingestion endpoint."
}
