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
# Provider configurations

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
}

provider "flux" {
  kubernetes = {
    host                   = module.cluster.kube_config.host
    client_certificate     = base64decode(module.cluster.kube_config.client_certificate)
    client_key             = base64decode(module.cluster.kube_config.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kube_config.cluster_ca_certificate)
  }

  git = {
    url                     = "https://gitlab.aldidevops.com/${local.gitops_project_path}.git"
    branch                  = var.stage
    commit_message_appendix = "Modified by Flux"

    http = {
      username = "flux"
      password = var.gitlab_token
    }
  }
}

provider "kubernetes" {
  host                   = module.cluster.kube_config.host
  client_certificate     = base64decode(module.cluster.kube_config.client_certificate)
  client_key             = base64decode(module.cluster.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.cluster.kube_config.cluster_ca_certificate)
}