##############################################################################
# Outputs
##############################################################################

#
# Developer tips:
#   - Include all relevant outputs from the modules being called in the example
#

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
