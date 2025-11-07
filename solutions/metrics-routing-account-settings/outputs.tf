##############################################################################
# Outputs
##############################################################################

output "metrics_router_account_settings" {
  description = "IBM Cloud metrics router account settings."
  value       = module.metrics_router_account_settings.metrics_router_settings
}
