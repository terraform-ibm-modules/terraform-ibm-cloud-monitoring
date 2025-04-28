##############################################################################
# Outputs
##############################################################################

output "resource_group_name" {
  description = "Resource group name"
  value       = module.resource_group.resource_group_name
}

output "cloud_monitoring_crn" {
  description = "Cloud Monitoring CRN"
  value       = module.cloud_monitoring.crn
}
