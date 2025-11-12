terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.69.2, < 2.0.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.5, <3.0.0"
    }
  }
}
