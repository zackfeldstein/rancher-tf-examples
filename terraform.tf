terraform {
  required_version = ">= 1.0"
  
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 3.0"
    }
  }
}

# Configure the Rancher2 Provider
provider "rancher2" {
  api_url    = var.rancher_api_url
  token_key  = var.rancher_token_key
  insecure   = var.rancher_insecure
} 