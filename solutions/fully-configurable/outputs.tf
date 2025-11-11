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
  description = "The id of the provisioned IBM Cloud Monitoring instance."
}
output "cloud_monitoring_name" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].name : null
  description = "The name of the provisioned IBM Cloud Monitoring instance."
}

output "cloud_monitoring_guid" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].guid : module.existing_cloud_monitoring_crn_parser[0].service_instance
  description = "The guid of the provisioned IBM Cloud Monitoring instance."
}

output "cloud_monitoring_access_key_name" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].access_key_name : null
  description = "The name of the IBM Cloud Monitoring access key for agents to use"
}

output "cloud_monitoring_access_key" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].access_key : null
  description = "The IBM Cloud Monitoring access key for agents to use"
  sensitive   = true
}

output "cloud_monitoring_resource_keys" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].resource_keys : null
  description = "A list of maps representing resource keys created for the IBM Cloud Monitoring instance."
  sensitive   = true
}

output "account_id" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].account_id : module.existing_cloud_monitoring_crn_parser[0].account_id
  description = "The account id where Cloud Monitoring instance is provisioned."
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

output "next_steps_text" {
  value       = "Your Cloud Monitoring instance is ready."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go to Cloud Monitoring instance"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = local.create_cloud_monitoring ? "https://cloud.ibm.com/observability/monitoring/${module.cloud_monitoring[0].guid}/overview" : "https://cloud.ibm.com/observability/monitoring/${module.existing_cloud_monitoring_crn_parser[0].service_instance}/overview"
  description = "Primary URL for the IBM Cloud Monitoring instance"
}

output "next_step_secondary_label" {
  value       = "Learn more about Cloud Monitoring"
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = "https://cloud.ibm.com/docs/monitoring?topic=monitoring-getting-started"
  description = "Secondary URL"
}
