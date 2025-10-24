output "crn" {
  value       = ibm_resource_instance.cloud_monitoring.id
  description = "The id of the provisioned cloud monitoring instance."
}

output "guid" {
  value       = ibm_resource_instance.cloud_monitoring.guid
  description = "The guid of the provisioned cloud monitoring instance."
}

output "account_id" {
  value       = ibm_resource_instance.cloud_monitoring.account_id
  description = "The account id where cloud monitoring instance is provisioned."
}

output "name" {
  value       = ibm_resource_instance.cloud_monitoring.name
  description = "The name of the provisioned cloud monitoring instance."
}

output "resource_group_id" {
  value       = ibm_resource_instance.cloud_monitoring.resource_group_id
  description = "The resource group where cloud monitoring monitor instance resides"
}

output "resource_keys" {
  description = "A list of maps representing resource keys created for the IBM Cloud Monitoring instance."
  value       = ibm_resource_key.resource_keys
  sensitive   = true
}

output "access_key_name" {
  value       = !var.disable_access_key_creation ? ibm_resource_key.resource_key[0].name : null
  description = "The Cloud Monitoring access key name"
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-access_key
output "access_key" {
  value       = !var.disable_access_key_creation ? ibm_resource_key.resource_key[0].credentials["Sysdig Access Key"] : null
  description = "The Cloud Monitoring access key for agents to use"
  sensitive   = true
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-endpoints#endpoints_ingestion
output "ingestion_endpoint_private" {
  value       = "ingest.private.${var.region}.monitoring.cloud.ibm.com"
  description = "The Cloud Monitoring private ingestion endpoint."
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-endpoints#endpoints_ingestion_public
output "ingestion_endpoint_public" {
  value       = "ingest.${var.region}.monitoring.cloud.ibm.com"
  description = "The Cloud Monitoring public ingestion endpoint."
}
