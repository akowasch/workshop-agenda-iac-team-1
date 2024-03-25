terraform {
  required_providers {
    azurerm = {
      # https://github.com/hashicorp/terraform-provider-azurerm/releases
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
    tls = {
      # https://github.com/hashicorp/terraform-provider-tls/releases
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  backend "azurerm" {}
}

################################################################################

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}
