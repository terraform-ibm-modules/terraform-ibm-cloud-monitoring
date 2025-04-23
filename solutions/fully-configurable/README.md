# IBM Cloud Cloud Monitoring deployable architecture

This deployable architecture creates a Cloud Monitoring instance in IBM Cloud and supports provisioning the following resources:

*

![cloud-monitoring-deployable-architecture]()

**Important:** Because this solution contains a provider configuration and is not compatible with the `for_each`, `count`, and `depends_on` arguments, do not call this solution from one or more other modules. For more information about how resources are associated with provider configurations with multiple modules, see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers).
