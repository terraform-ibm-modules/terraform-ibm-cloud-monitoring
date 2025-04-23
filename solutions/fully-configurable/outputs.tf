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
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].guid : null
  description = "The guid of the provisioned IBM cloud monitoring instance."
}

output "cloud_monitoring_access_key" {
  value       = local.create_cloud_monitoring ? module.cloud_monitoring[0].access_key : null
  description = "IBM cloud monitoring access key for agents to use"
  sensitive   = true
}

output "account_id" {
  value       = module.cloud_monitoring[0].account_id
  description = "The account id where cloud monitoring instance is provisioned."
}
