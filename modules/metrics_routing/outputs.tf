########################################################################
# Metric Router Event Routing
#########################################################################

# Metric Routing Target

output "metrics_router_targets" {
  value       = ibm_metrics_router_target.metrics_router_targets
  description = "The created metrics routing targets."
}

# Metric Routing Routes

output "metrics_router_routes" {
  value       = ibm_metrics_router_route.metrics_router_routes
  description = "The created metrics routing routes."
}

# Metric Routing Global Settings

output "metrics_router_settings" {
  value       = ibm_metrics_router_settings.metrics_router_settings
  description = "The global metrics routing settings."
}

output "metrics_router_target_crns" {
  value       = { for target_name, target_resource in ibm_metrics_router_target.metrics_router_targets : target_name => target_resource.destination_crn }
  description = "Map of metrics router target names to their destination CRNs."
}
