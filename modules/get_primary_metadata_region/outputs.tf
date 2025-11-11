########################################################################
# Metric Routing Account Settings
#########################################################################

output "primary_metadata_region" {
  value       = nonsensitive(data.external.get_primary_metadata_region.result.primary_metadata_region)
  description = "Primary metadata region for IBM Cloud Metrics Router"
}
