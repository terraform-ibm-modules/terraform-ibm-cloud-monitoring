##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud API Key."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The IBM Cloud region."
  type        = string
  default     = "us-south"
}

variable "use_private_endpoint" {
  type        = bool
  description = "Make true to hit the private endpoint."
  default     = false
}
