########################################################################
# Metrics Routing Primary Metadata Region
#########################################################################

data "external" "get_primary_metadata_region" {
  program = [
    "bash",
    "-c",
    "IBM_API_KEY='${var.ibmcloud_api_key}' ${path.module}/scripts/get_primary_metadata_region.sh"
  ]

  query = {
    region               = var.region
    use_private_endpoint = var.use_private_endpoint
  }
}
