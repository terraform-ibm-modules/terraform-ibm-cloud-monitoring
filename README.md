<!-- Update this title with a descriptive name. Use sentence case. -->
# IBM Cloud Monitoring module

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-cloud-monitoring?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-cloud-monitoring/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!--
Add a description of modules in this repo.
Expand on the repo short description in the .github/settings.yml file.

For information, see "Module names and descriptions" at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=module-names-and-descriptions
-->

This module supports configuring an IBM Cloud Monitoring instance, metrics routing target and routes.

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-cloud-monitoring](#terraform-ibm-cloud-monitoring)
* [Examples](./examples)
    * [Advanced Examples](./examples/advanced)
    * [Basic example](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

<!--
If this repo contains any reference architectures, uncomment the heading below and link to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->

<!-- Replace this heading with the name of the root level module (the repo name) -->
## terraform-ibm-cloud-monitoring

### Usage

<!--
Add an example of the use of the module in the following code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "X.Y.Z"  # Lock into a provider version that satisfies the module constraints
    }
  }
}

locals {
    region = "us-south"
}

provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"  # replace with apikey value
  region           = local.region
}

module "module_template" {
  source            = "terraform-ibm-modules/<replace>/ibm"
  version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  region            = local.region
  name              = "instance-name"
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX" # Replace with the actual ID of resource group to use
}
```

### Required access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the 'Sample IBM Cloud' service and roles with applicable values.
The required information can usually be found in the services official
IBM Cloud documentation.
To view all available service permissions, you can go in the
console at Manage > Access (IAM) > Access groups and click into an existing group
(or create a new one) and in the 'Access' tab click 'Assign access'.
-->

<!--
You need the following permissions to run this module:

- Service
    - **Resource group only**
        - `Viewer` access on the specific resource group
    - **Sample IBM Cloud** service
        - `Editor` platform access
        - `Manager` service access
-->

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.70.0, < 2.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1, < 1.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_iam_authorization_policy.metrics_router_cloud_monitoring](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_metrics_router_route.metrics_router_routes](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/metrics_router_route) | resource |
| [ibm_metrics_router_settings.metrics_router_settings](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/metrics_router_settings) | resource |
| [ibm_metrics_router_target.metrics_router_targets](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/metrics_router_target) | resource |
| [ibm_resource_instance.cloud_monitoring](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_key.resource_key](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_key) | resource |
| [ibm_resource_tag.cloud_monitoring_tag](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_tag) | resource |
| [time_sleep.wait_for_cloud_monitoring_auth_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | Access Management Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings). | `list(string)` | `[]` | no |
| <a name="input_enable_platform_metrics"></a> [enable\_platform\_metrics](#input\_enable\_platform\_metrics) | Receive platform metrics in the provisioned IBM Cloud Monitoring instance. | `bool` | `false` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the IBM Cloud Monitoring instance to create. Defaults to 'cloud-monitoring-<region>' | `string` | `null` | no |
| <a name="input_manager_key_name"></a> [manager\_key\_name](#input\_manager\_key\_name) | The name to give the IBM Cloud Monitoring manager key. | `string` | `"SysdigManagerKey"` | no |
| <a name="input_manager_key_tags"></a> [manager\_key\_tags](#input\_manager\_key\_tags) | Tags associated with the IBM Cloud Monitoring manager key. | `list(string)` | `[]` | no |
| <a name="input_metrics_router_routes"></a> [metrics\_router\_routes](#input\_metrics\_router\_routes) | List of routes for IBM Metrics Router | <pre>list(object({<br>    name = string<br>    rules = list(object({<br>      action = optional(string, "send")<br>      targets = optional(list(object({<br>        id = string<br>      })))<br>      inclusion_filters = list(object({<br>        operand  = string<br>        operator = string<br>        values   = list(string)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_metrics_router_settings"></a> [metrics\_router\_settings](#input\_metrics\_router\_settings) | Global settings for Metrics Routing | <pre>object({<br>    permitted_target_regions  = optional(list(string))<br>    primary_metadata_region   = optional(string)<br>    backup_metadata_region    = optional(string)<br>    private_api_endpoint_only = optional(bool, false)<br>    default_targets = optional(list(object({<br>      id = string<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_metrics_router_targets"></a> [metrics\_router\_targets](#input\_metrics\_router\_targets) | List of Metrics Router targets to be created. | <pre>list(object({<br>    destination_crn                     = string<br>    target_name                         = string<br>    target_region                       = optional(string)<br>    skip_mrouter_sysdig_iam_auth_policy = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The IBM Cloud Monitoring plan to provision. Available: lite, graduated-tier | `string` | `"lite"` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where instances will be created. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The id of the IBM Cloud resource group where the instance(s) will be created. | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The type of the service endpoint that will be set for the Sisdig instance. | `string` | `"public-and-private"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings). | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | The cloud monitoring access key for agents to use |
| <a name="output_crn"></a> [crn](#output\_crn) | The id of the provisioned cloud monitoring instance. |
| <a name="output_guid"></a> [guid](#output\_guid) | The guid of the provisioned cloud monitoring instance. |
| <a name="output_manager_key_name"></a> [manager\_key\_name](#output\_manager\_key\_name) | The cloud monitoring manager key name |
| <a name="output_metrics_router_routes"></a> [metrics\_router\_routes](#output\_metrics\_router\_routes) | The created metrics routing routes. |
| <a name="output_metrics_router_settings"></a> [metrics\_router\_settings](#output\_metrics\_router\_settings) | The global metrics routing settings. |
| <a name="output_metrics_router_targets"></a> [metrics\_router\_targets](#output\_metrics\_router\_targets) | The created metrics routing targets. |
| <a name="output_name"></a> [name](#output\_name) | The name of the provisioned cloud monitoring instance. |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The resource group where cloud monitoring monitor instance resides |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
