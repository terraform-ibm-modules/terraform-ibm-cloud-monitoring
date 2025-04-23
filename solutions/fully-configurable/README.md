# Cloud automation for Cloud Monitoring (Fully configurable)

## Prerequisites

- An existing resource group

This solution supports provisioning and configuring the following infrastructure:

- A Cloud Monitoring instance.
- An IBM Cloud Metrics Routing route to a Cloud Monitoring target.

![cloud-monitoring-deployable-architecture](../../reference-architecture/deployable-architecture-cloud-monitoring.svg)

**Important:** Because this solution contains a provider configuration and is not compatible with the `for_each`, `count`, and `depends_on` arguments, do not call this solution from one or more other modules. For more information about how resources are associated with provider configurations with multiple modules, see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers).
