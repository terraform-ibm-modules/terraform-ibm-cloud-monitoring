# IBM Cloud Monitoring module

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-cloud-monitoring?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-cloud-monitoring/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

This module supports configuring an IBM Cloud Monitoring instance, metrics routing target, routes and settings.

## Overview

* [terraform-ibm-cloud-monitoring](#terraform-ibm-cloud-monitoring)
* [Submodules](./modules)
  * [metrics_routing](./modules/metrics_routing)
* [Examples](./examples)
  * [Advanced example](./examples/advanced)
  * [Basic example](./examples/basic)
* [Contributing](#contributing)

## terraform-ibm-cloud-monitoring

### Usage

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
    default_operations = [{
      api_types = [
        {
          "api_type_id" : "crn:v1:bluemix:public:context-based-restrictions::::api-type:"
        }
      ]
    }]
}

provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"  # replace with apikey value
  region           = local.region
}

# IBM Cloud Monitoring

module "cloud_monitoring" {
  source            = "terraform-ibm-modules/cloud-monitoring/ibm"
  version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  region            = local.region
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"

  # CBR
  cbr_rules = [{
    description      = "Rules for cloud monitoring access"
    account_id       = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
    enforcement_mode = "report"
    rule_contexts = [{
      attributes = [
        {
          "name" : "endpointType",
          "value" : "private"
        },
        {
          name  = "networkZoneId"
          value = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
        }
      ]
      }]
      operations = local.default_operations
  }]
}

# IBM Cloud Metrics Routing

module "metric_router" {
  source    = "terraform-ibm-modules/cloud_monitoring/ibm//modules/metrics_routing"
  version   = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release

  metrics_router_targets = [
    {
      # ID of the Cloud Monitoring instance
      destination_crn   = "crn:v1:bluemix:public:sysdig-monitor:eu-de:a/xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX:xxxxxx-XXXX-XXXX-XXXX-xxxxxx::"
      target_region = "us-south"
      target_name   = "cloud-monitoring-target"
    }
  ]

  metrics_router_routes = [
    {
        name = "my-mr-route"
        rules = [
            {
                action = "send"
                targets = [{
                    id = module.metric_router.metric_router_targets["cloud-monitoring-target"].id
                }]
                inclusion_filters = [{
                    operand = "location"
                    operator = "is"
                    values = ["us-east"]
                }]
            }
        ]
    }
  ]

  metrics_router_settings = {
    default_targets = [{
      id = module.metrics_routing.metrics_router_targets["cloud-monitoring-target"].id
    }]
    permitted_target_regions  = ["us-south", "eu-de", "us-east", "eu-es", "eu-gb"]
    primary_metadata_region   = "us-south" # To configure metrics routing, the account must have a `primary_metadata_region` set.
    private_api_endpoint_only = false  # You will be unable to view the metrics routing account settings in the UI if `private_api_endpoint_only` is set to true.
                                       # For more information, see https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-settings-about&interface=ui.
  }
}

```

### Required access policies

You need the following permissions to run this module.

* Service
  * **Resource group only**
    * `Viewer` access on the specific resource group
  * **Cloud Monitoring**
    * `Editor` platform access
    * `Manager` service access
  * **IBM Cloud Metrics Routing** (Required if creating metrics routing routes & target)
    * `Editor` platform access
    * `Manager` service access

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.79.0, < 2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cbr_rule"></a> [cbr\_rule](#module\_cbr\_rule) | terraform-ibm-modules/cbr/ibm//modules/cbr-rule-module | 1.33.2 |

### Resources

| Name | Type |
|------|------|
| [ibm_resource_instance.cloud_monitoring](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_key.resource_keys](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_key) | resource |
| [ibm_resource_tag.cloud_monitoring_tag](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/resources/resource_tag) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | Access Management Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings). | `list(string)` | `[]` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of context-based restrictions rules to create | <pre>list(object({<br/>    description = string<br/>    account_id  = string<br/>    rule_contexts = list(object({<br/>      attributes = optional(list(object({<br/>        name  = string<br/>        value = string<br/>    }))) }))<br/>    enforcement_mode = string<br/>    operations = optional(list(object({<br/>      api_types = list(object({<br/>        api_type_id = string<br/>      }))<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_platform_metrics"></a> [enable\_platform\_metrics](#input\_enable\_platform\_metrics) | Receive platform metrics in the provisioned IBM Cloud Monitoring instance. Only 1 instance in a given region can be enabled for platform metrics. | `bool` | `false` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the IBM Cloud Monitoring instance to create. Defaults to 'cloud-monitoring-<region>' | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The IBM Cloud Monitoring plan to provision. Available: lite, graduated-tier and graduated-tier-sysdig-secure-plus-monitor (available in region eu-fr2 only) | `string` | `"lite"` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where Cloud Monitoring instance will be created. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The id of the IBM Cloud resource group where the Cloud Monitoring instance will be created. | `string` | n/a | yes |
| <a name="input_resource_keys"></a> [resource\_keys](#input\_resource\_keys) | List of access keys to create for the IBM Cloud Monitoring instance. These keys are used by monitoring agents to forward data. Each entry defines one resource key. For guidance on access keys, see: https://cloud.ibm.com/docs/monitoring?topic=monitoring-access_key | <pre>list(object({<br/>    name                      = string<br/>    key_name                  = optional(string, null)<br/>    generate_hmac_credentials = optional(bool, false) # pragma: allowlist secret<br/>    role                      = optional(string, "Manager")<br/>    service_id_crn            = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "generate_hmac_credentials": false,<br/>    "key_name": "SysdigManagerKey",<br/>    "name": "SysdigManagerKey",<br/>    "role": "Manager",<br/>    "service_id_crn": null<br/>  }<br/>]</pre> | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Tags associated with the IBM Cloud Monitoring instance (Optional, array of strings). | `list(string)` | `[]` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The type of the service endpoint that will be set for the Sisdig instance. | `string` | `"public-and-private"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_keys"></a> [access\_keys](#output\_access\_keys) | The Cloud Monitoring access keys for agents to use. |
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The account id where cloud monitoring instance is provisioned. |
| <a name="output_crn"></a> [crn](#output\_crn) | The id of the provisioned cloud monitoring instance. |
| <a name="output_guid"></a> [guid](#output\_guid) | The guid of the provisioned cloud monitoring instance. |
| <a name="output_ingestion_endpoint_private"></a> [ingestion\_endpoint\_private](#output\_ingestion\_endpoint\_private) | The Cloud Monitoring private ingestion endpoint. |
| <a name="output_ingestion_endpoint_public"></a> [ingestion\_endpoint\_public](#output\_ingestion\_endpoint\_public) | The Cloud Monitoring public ingestion endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The name of the provisioned cloud monitoring instance. |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The resource group where cloud monitoring monitor instance resides |
| <a name="output_resource_keys"></a> [resource\_keys](#output\_resource\_keys) | Map of resource keys created for the IBM Cloud Monitoring instance, used by agents for authentication and data forwarding. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
