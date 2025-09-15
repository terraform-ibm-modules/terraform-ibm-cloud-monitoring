# Advanced example

Example that configures:

- A new resource group if one is not passed in.
- A context-based restriction (CBR) zone for the IBM Cloud Schematics service.
- An IBM Cloud Monitoring instance.
- A context-based restriction (CBR) rule to only allow the Cloud Monitoring to be accessible from the Schematics zone.
- A Metrics Routing target for the new IBM Cloud Monitoring instance and a route to route send metrics to it.
