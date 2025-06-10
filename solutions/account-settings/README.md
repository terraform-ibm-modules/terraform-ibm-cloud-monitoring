# Cloud automation for Cloud Monitoring (Account Settings)

This solution supports configuring the IBM Cloud Metrics Router Account Settings.

## IBM Cloud Metrics Routing Account Settings

Through the IBM Cloud Metrics Routing account settings, you can configure the following:

### Metadata Storage Location

- Set the primary and optional backup region for storing routing metadata.

- Defaults to the region of the first configured target if not set.

### Endpoint Access

- Control whether public and/or private endpoints can manage settings.

- Default: both enabled; can restrict to private only.
s

### Target Locations

- Choose regions where admins can define metric collection targets, based on compliance needs.

### Default Target Locations

- Set default targets to collect metrics from regions without specific configuration.

**Important:** Because this solution contains a provider configuration and is not compatible with the `for_each`, `count`, and `depends_on` arguments, do not call this solution from one or more other modules. For more information about how resources are associated with provider configurations with multiple modules, see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers).
