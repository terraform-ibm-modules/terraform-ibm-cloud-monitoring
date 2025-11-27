# Primary Metadata Region

This module retrieves the `primary_metadata_region` value from the IBM Cloud Metrics Routing Account Settings.

### Customizing default cloud service endpoints

The user must export the endpoint as an environment variable in order to use custom cloud service endpoints with this module. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints#getting-started-with-custom-service-endpoints).

**Important** The only supported method for customizing cloud service endpoints is to export the environment variables endpoint; be sure to export the value for `IBMCLOUD_METRICS_ROUTING_API_ENDPOINT`. For example,

```
export IBMCLOUD_METRICS_ROUTING_API_ENDPOINT="<endpoint_url>"
```

## Usage

```hcl

provider "ibm" {
  ibmcloud_api_key      = "XXXXXXXXXXXXXXXXXXXXXXXX"  # pragma: allowlist secret
}

module "metrics_router" {
  source = "terraform-ibm-modules/cloud-monitoring/ibm//modules/get_primary_metadata_region"
  region              = "us-south"
  use_private_endpoint = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.3.5, <3.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.69.2, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [external_external.get_primary_metadata_region](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [ibm_iam_auth_token.token](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/data-sources/iam_auth_token) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API Key. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud Metrics Routing region. | `string` | `"us-south"` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Set to true to use the private endpoints instead of public endpoints for IBM Cloud Metrics Routing service. When true, the script queries the private Metrics Routing endpoint for the given region. [Learn more](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-endpoints) | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_primary_metadata_region"></a> [primary\_metadata\_region](#output\_primary\_metadata\_region) | The current primary metadata region set for IBM Cloud Metrics Routing. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
