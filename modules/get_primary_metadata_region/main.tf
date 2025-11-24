########################################################################
# Metrics Routing Primary Metadata Region
#########################################################################

data "external" "get_primary_metadata_region" {
  program = ["python3", "${path.module}/scripts/primary_metadata_region.py"]

  query = {
    IBM_API_KEY          = var.ibmcloud_api_key
    region               = var.region
    use_private_endpoint = var.use_private_endpoint
  }
}
