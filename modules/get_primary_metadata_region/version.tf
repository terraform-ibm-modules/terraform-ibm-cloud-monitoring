terraform {
  required_version = ">= 1.9.0"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1, < 1.0.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.5"
    }
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.78.2, < 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1, < 4.0.0"
    }
  }
}
