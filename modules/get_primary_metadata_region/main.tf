########################################################################
# IBM Cloud Metric Routing
#########################################################################

resource "time_sleep" "wait_iam_token" {
  create_duration = "5s"
}

data "external" "get_primary_metadata_region" {
  depends_on = [time_sleep.wait_iam_token]
  program    = ["bash", "${path.module}/scripts/get_primary_metadata_region.sh"]

  query = {
    IBM_API_KEY          = var.ibmcloud_api_key
    region               = var.region
    use_private_endpoint = var.use_private_endpoint
  }
}


