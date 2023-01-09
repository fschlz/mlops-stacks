# defining the providers for the recipe module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.28.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }

  required_version = ">= 0.14.8"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
