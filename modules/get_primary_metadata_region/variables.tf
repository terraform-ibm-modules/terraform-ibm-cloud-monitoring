##############################################################################
# Input Variables
##############################################################################

variable "use_private_endpoint" {
  type        = bool
  description = "Set to true to use the private endpoints instead of public endpoints for IBM Cloud Metrics Routing service. When true, the script queries the private Metrics Routing endpoint. [Learn more](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-endpoints)"
  default     = false
}
