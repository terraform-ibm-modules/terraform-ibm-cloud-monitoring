# Configuring complex inputs for Cloud Automation for Cloud Monitoring

Several optional input variables in the IBM Cloud [Cloud Monitoring instances deployable architecture](https://cloud.ibm.com/catalog#deployable_architecture) use complex object types. You specify these inputs when you configure deployable architecture.

* [IBM Cloud Metrics Router Routes](#metrics_router_routes) (`metrics_router_routes`)
* [Context Based Restrictions Rules](#cbr_rules) (`cbr_rules`)
* [Cloud Monitoring Resource Keys](#cloud_monitoring_resource_keys) (`cloud_monitoring_resource_keys`)

## Metrics Router Routes <a name="metrics_router_routes"></a>

The `metrics_router_routes` input variable allows you to provide a list of routes that will be configured in the IBM Cloud Metrics Routing. Refer [here](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-about) for more information.

* Variable name: `metrics_router_routes`.
* Type: A list of objects. Each object represents a route.
* Default value: An empty list (`[]`).

### Options for metrics_router_routes

* `name` (required):  The name of the route.
* `rules` (required): The routing rules that will be evaluated in their order of the array. You can configure up to 10 rules per route.
  * `action` (optional): The action if the inclusion_filters matches, default is send action. Allowed values are `send` and `drop`.
  * `inclusion_filters` (required): A list of conditions to be satisfied for routing metrics to pre-defined target. `inclusion_filters` is an object with three parameters:
    * `operand` - Part of CRN that can be compared with values. Allowable values are: `location`, `service_name`, `service_instance`, `resource_type`, `resource`.

    * `operator` - The operation to be performed between operand and the provided values. Allowable values are: `is`, `in`.

    * `values` - The provided string values of the operand to be compared with.
  * `targets` (required): The target uuid for a pre-defined metrics router target.

### Example route for Metrics Router Routes Configuration

```hcl
[
    {
    name = "my-route"
    rules {
        action = "send"
        targets {
            id = "c3af557f-fb0e-4476-85c3-0889e7fe7bc4"
        }
        inclusion_filters {
            operand = "location"
            operator = "is"
            values = [ "us-south" ]
        }
        }
    }
]
```

## Rules For Context-Based Restrictions <a name="cbr_rules"></a>

The `cbr_rules` input variable allows you to provide a rule for the target service to enforce access restrictions for the service based on the context of access requests. Contexts are criteria that include the network location of access requests, the endpoint type from where the request is sent, etc.

* Variable name: `cbr_rules`.
* Type: A list of objects. Allows only one object representing a rule for the target service
* Default value: An empty list (`[]`).

### Options for cbr_rules

* `description` (required): The description of the rule to create.
* `account_id` (required): The IBM Cloud Account ID
* `rule_contexts` (required): (List) The contexts the rule applies to
  * `attributes` (optional): (List) Individual context attributes
    * `name` (required): The attribute name.
    * `value` (required): The attribute value.
* `enforcement_mode` (required): The rule enforcement mode can have the following values:
  * `enabled` - The restrictions are enforced and reported. This is the default.
  * `disabled` - The restrictions are disabled. Nothing is enforced or reported.
  * `report` - The restrictions are evaluated and reported, but not enforced.
* `operations` (optional): The operations this rule applies to
  * `api_types`(required): (List) The API types this rule applies to.
    * `api_type_id`(required):The API type ID

### Example Rule For Context-Based Restrictions Configuration

```hcl
[
  {
    description = "cloud monitoring can be accessed from xyz"
    account_id = "defc0df06b644a9cabc6e44f55b3880s."
    rule_contexts= [
      {
        attributes = [
          {
            "name" : "endpointType",
            "value" : "private"
          },
          {
            name  = "networkZoneId"
            value = "93a51a1debe2674193217209601dde6f" # pragma: allowlist secret
          }
        ]
      }
    ]
    enforcement_mode = "enabled"
    operations = [
      {
        api_types = [
          {
            api_type_id = "crn:v1:bluemix:public:context-based-restrictions::::api-type:"
          }
        ]
      }
    ]
  }
]
```

## Cloud Monitoring Resource Keys <a name="cloud_monitoring_resource_keys"></a>

The `cloud_monitoring_resource_keys` input variable allows you to provide a list of resource key to create that will be configured in the IBM Cloud Monitoring instance. In the configuration, specify the name of the resource key, whether HMAC credentials should be included, the role of the key, the endpoint type, and an optional Service ID CRN to create with a Service ID. Refer [here](https://cloud.ibm.com/docs/monitoring?topic=monitoring-access_key) for more information.

* Variable name: `cloud_monitoring_resource_keys`.
* Type: A list of objects that represent a resource key
* Default value:

  ```
    {
      name                      = "SysdigManagerKey"
      generate_hmac_credentials = false
      role                      = "Manager"
      service_id_crn            = null
      endpoint                  = "private"
    }
  ```

### Options for cloud_monitoring_resource_keys

* `name` (required): A unique human-readable name that identifies this resource key.
* `generate_hmac_credentials` (optional, default = `false`): Set to true to include HMAC keys in the resource key. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key#example-to-create-by-using-hmac).
* `role` (optional, default = `Reader`): The name of the user role.
* `service_id_crn` (optional, default = `null`): Pass a Service ID CRN to create credentials for a resource with a Service ID. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key#example-to-create-by-using-serviceid).
* `endpoint` (optional, default = `private`): The endpoint of resource key.

### Example route for Cloud Monitoring Resource Keys

The following example includes all the configuration options for two resource keys. One is a HMAC key with a `Reader` role, the other with an IAM key with `Manager` role.

```hcl
[
  {
    "name": "icm-resource-key",
    "generate_hmac_credentials": true,
    "role": "Reader",
    "endpoint": "private"
  },
  {
    "name": "icm-resource-key",
    "role": "Manager",
    "endpoint": "public"
  }
]
```
