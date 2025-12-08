##############################################################################
# Input Variables
##############################################################################

variable "region" {
  description = "The IBM Cloud Metrics Routing region."
  type        = string
  default     = "us-south"
}

variable "use_private_endpoint" {
  type        = bool
  description = "Set to true to use the private endpoints instead of public endpoints for IBM Cloud Metrics Routing service. When true, the script queries the private Metrics Routing endpoint for the given region. [Learn more](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-endpoints)"
  default     = false
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}
