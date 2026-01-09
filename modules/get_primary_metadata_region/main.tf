########################################################################
# Metrics Routing Primary Metadata Region
#########################################################################

data "ibm_iam_auth_token" "token" {}

data "external" "get_primary_metadata_region" {
  program = ["python3", "${path.module}/scripts/primary_metadata_region.py"]

  query = {
    iam_access_token     = sensitive(data.ibm_iam_auth_token.token.iam_access_token)
    use_private_endpoint = var.use_private_endpoint
  }

  lifecycle {
    precondition {
      # This ensures the token exists before the script is triggered
      condition     = data.ibm_iam_auth_token.token.iam_access_token != null && data.ibm_iam_auth_token.token.iam_access_token != ""
      error_message = "The IBM `iam_access_token` is missing or empty. The external script needs the token to execute and fetch the `primary_metadata_region`."
    }
  }
}
