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
  description = "Map of resource keys created for the IBM Cloud Monitoring instance, used by agents for authentication and data forwarding."
  value       = ibm_resource_key.resource_keys
  sensitive   = true
}

# https://cloud.ibm.com/docs/monitoring?topic=monitoring-access_key
output "access_keys" {
  description = "The Cloud Monitoring access keys for agents to use."
  value = {
    for name, key in ibm_resource_key.resource_keys :
    name => key.credentials["Sysdig Access Key"]
  }
  sensitive = true
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
