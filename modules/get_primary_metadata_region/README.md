# Primary Metadata Region

This module retrieves the `primary_metadata_region` value from the IBM Cloud Metrics Settings for a given region.

### Prerequisites

This module utilizes an external script that relies on the following command-line tools being installed on the system where Terraform is executed:

- `jq`: A lightweight and flexible command-line JSON processor. It is required for parsing the input provided by the Terraform external data source.
- `curl`: A tool to transfer data with URLs, required for making API calls to the IBM Cloud Enterprise Management API.

## Usage

```hcl
module "metrics_router" {
  source = ""terraform-ibm-modules/cloud-monitoring/ibm//modules/get_primary_metadata_region""

  ibmcloud_api_key    = "XXXXXXXXXXXXXXXXXXXXXXXX"
  region              = "us-south"
  use_private_endpoint = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | 2.3.5 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.78.2, < 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1, < 4.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1, < 1.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [external_external.get_primary_metadata_region](https://registry.terraform.io/providers/hashicorp/external/2.3.5/docs/data-sources/external) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API Key. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region. | `string` | `"us-south"` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Make true to hit the private endpoint. | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_primary_metadata_region"></a> [primary\_metadata\_region](#output\_primary\_metadata\_region) | The current primary metadata region set for IBM Cloud Metrics Routing. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
