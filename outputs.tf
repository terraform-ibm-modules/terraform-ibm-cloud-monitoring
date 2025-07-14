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

output "access_key" {
  value       = ibm_resource_key.resource_key.credentials["Sysdig Access Key"]
  description = "The cloud monitoring access key for agents to use"
  sensitive   = true
}

output "manager_key_name" {
  value       = ibm_resource_key.resource_key.name
  description = "The cloud monitoring manager key name"
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
