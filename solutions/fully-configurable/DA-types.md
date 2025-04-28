# Configuring complex inputs for Cloud Automation for Cloud Monitoring

Several optional input variables in the IBM Cloud [Cloud Monitoring instances deployable architecture](https://cloud.ibm.com/catalog#deployable_architecture) use complex object types. You specify these inputs when you configure deployable architecture.

* [IBM Cloud Metrics Router Routes](#metrics_router_routes) (`metrics_router_routes`)

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
