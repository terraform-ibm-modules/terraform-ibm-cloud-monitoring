#######################################################################################################################
# IBM Cloud Metrics Routing
#######################################################################################################################

module "metrics_router_account_settings" {
  source = "../../modules/metrics_routing"

  metrics_router_settings = {
    default_targets           = var.default_targets
    permitted_target_regions  = var.permitted_target_regions
    primary_metadata_region   = var.primary_metadata_region
    backup_metadata_region    = var.backup_metadata_region
    private_api_endpoint_only = var.private_api_endpoint_only
  }
}
