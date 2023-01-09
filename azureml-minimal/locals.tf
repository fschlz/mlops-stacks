# config values to use across the module
locals {
  prefix = "azmlopsmvp"
  region = "westeurope"

  resource_group = {
    name     = "rg"
    location = local.region
  }

  azureml = {
    name = "azureml"
  }

  vpc = {
    name = "vpc"
  }

  blob_storage = {
    account_name   = "account"
    container_name = "artifactstore"
  }

  key_vault = {
    name = "secrets"
  }

  tags = {
    "managed-by"   = "terraform"
    "project" = local.prefix
    "environemnt" = "dev"
  }
}
