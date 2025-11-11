########################################################################
# IBM Cloud Metric Routing
#########################################################################

# data "ibm_iam_auth_token" "tokendata" {
# }
# 
resource "time_sleep" "wait_iam_token" {
  # depends_on      = [data.ibm_iam_auth_token.tokendata]
  create_duration = "5s"
}

# resource "null_resource" "primary_metadata_region" {
#   # depends_on = [time_sleep.wait_iam_token]
#   provisioner "local-exec" {
#     command = "bash ${path.module}/scripts/get_primary_metadata_region.sh"
#     environment = {
#       ibmcloud_api_key     = var.ibmcloud_api_key
#       REGION               = var.region
#       USE_PRIVATE_ENDPOINT = var.use_private_endpoint
#     }
#   }
# }

data "external" "get_primary_metadata_region" {
  depends_on = [time_sleep.wait_iam_token]
  program    = ["bash", "${path.module}/scripts/get_primary_metadata_region.sh"]

  query = {
    IBM_API_KEY          = var.ibmcloud_api_key
    region               = var.region
    use_private_endpoint = var.use_private_endpoint
  }
}


