########################################################################
# Output
#########################################################################

output "primary_metadata_region" {
  value       = nonsensitive(data.external.get_primary_metadata_region.result.primary_metadata_region)
  description = "The current primary metadata region set for IBM Cloud Metrics Routing."
}
