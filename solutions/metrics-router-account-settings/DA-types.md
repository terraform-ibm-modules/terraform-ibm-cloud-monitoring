# Configuring complex inputs for Cloud Automation for Cloud Monitoring

Several optional input variables in the IBM Cloud [Cloud Monitoring account settings deployable architecture](https://cloud.ibm.com/catalog#deployable_architecture) use complex object types. You specify these inputs when you configure deployable architecture.

* [Metrics Router Default target](#default_targets) (`default_targets`)
* [Metrics Router Permitted target region](#permitted_target_regions) (`permitted_target_regions`)

## Default targets <a name="default_targets"></a>

The `default_targets` input variable allows you to provide a list of targets that will be configured as a target for IBM Cloud Metrics Routing. Refer [here](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-settings-about&interface=ui) for more information.

* Variable name: `default_targets`.
* Type: A list of objects. Each object represents a target.
* Default value: An empty list (`[]`).

### Options for default_targets

* `id` (required):  The id of the Cloud Monitoring target.

### Example route for default target configuration

```hcl
[
    {
        id = "c3af557f-fb0e-4476-85c3-0889e7fe7bc4"
    }
]
```
