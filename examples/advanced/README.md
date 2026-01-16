# Advanced example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=cloud-monitoring-advanced-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-cloud-monitoring/tree/main/examples/advanced"><img src="https://img.shields.io/badge/Deploy%20with IBM%20Cloud%20Schematics-0f62fe?logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom;"></a>
<!-- END SCHEMATICS DEPLOY HOOK -->


Example that configures:

- A new resource group if one is not passed in.
- A context-based restriction (CBR) zone for the IBM Cloud Schematics service.
- An IBM Cloud Monitoring instance.
- A context-based restriction (CBR) rule to only allow the Cloud Monitoring to be accessible from the Schematics zone.
- A Metrics Routing target for the new IBM Cloud Monitoring instance and a route to send metrics to it.

<!-- BEGIN SCHEMATICS DEPLOY TIP HOOK -->
:information_source: Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab
<!-- END SCHEMATICS DEPLOY TIP HOOK -->
