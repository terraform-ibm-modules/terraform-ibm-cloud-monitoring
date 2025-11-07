##############################################################################
# Outputs
##############################################################################

output "metrics_router_account_settings" {
  description = "IBM Cloud metrics router account settings."
  value       = module.metrics_router_account_settings.metrics_router_settings
}

output "next_steps_text" {
  value       = "Your Cloud Monitoring Instance is ready."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go to Cloud Monitoring Instance"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = "https://cloud.ibm.com/observability/metrics-router/${module.metrics_router_account_settings.metrics_router_target_crns}/overview"
  description = "Primary URL for the IBM Cloud Logs instance"
}

output "next_step_secondary_label" {
  value       = "Learn more about Metrics Routing"
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = "https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-settings-about&interface=ui"
  description = "Secondary URL"
}
