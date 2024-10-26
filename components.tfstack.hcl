required_providers {
  azapi = {
    source  = "Azure/azapi"
    version = "~> 2.0"
  }
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 3.99"
  }
  modtm = {
    source  = "azure/modtm"
    version = "~> 0.3"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6"
  }
}

provider "azurerm" "management" {
  config {
    features {}
    client_id       = var.client_id
    oidc_token      = var.identity_token
    subscription_id = var.subscription_id_management
    tenant_id       = var.tenant_id
    use_cli         = false
    use_msi         = false
    use_oidc        = true
  }
}

provider "azapi" "management" {
  config {
    client_id       = var.client_id
    oidc_token      = var.identity_token
    subscription_id = var.subscription_id_management
    tenant_id       = var.tenant_id
    use_cli         = false
    use_msi         = false
    use_oidc        = true
  }
}

provider "modtm" "all" {
  config {}
}

provider "random" "all" {
  config {}
}

component "alz_management" {
  source = "git::https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management.git?ref=stacks"
  # version = "0.4.0"
  providers = {
    azapi   = provider.azapi.management
    azurerm = provider.azurerm.management
    modtm   = provider.modtm.all
    random  = provider.random.all
  }
  inputs = {
    automation_account_name           = var.automation_account_name
    linked_automation_account_enabled = false
    location                          = var.location
    location                          = var.location
    log_analytics_workspace_name      = var.log_analytics_workspace_name
    resource_group_name               = "rg-management"
  }
}
