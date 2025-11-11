##############################################################################
# Outputs
##############################################################################

output "metrics_router_account_settings" {
  description = "IBM Cloud metrics router account settings."
  value       = module.metrics_router_account_settings.metrics_router_settings
}

output "next_steps_text" {
  value       = "Activity Tracker Event Routing targets and routes are created"
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go to Metrics Roting overview page"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = "https://cloud.ibm.com/observability/metrics-routing/overview"
  description = "Primary URL"
}

output "next_step_secondary_label" {
  value       = "Learn more about metrics router account settings"
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = "https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-settings-about&interface=ui"
  description = "Secondary URL"
}
