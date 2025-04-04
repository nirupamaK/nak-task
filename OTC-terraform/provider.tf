terraform {
  required_providers {
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
      version = "1.36.34"
    }
  }
}

provider "opentelekomcloud" {
  region      = "eu-de"
  user_name   = var.username
  password    = var.password
  tenant_name = var.tenant_name
  domain_name = var.domain_name
  auth_url    = var.endpoint
}