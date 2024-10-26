required_providers {
  azapi = {
    source  = "Azure/azapi"
    version = "~> 2.0"
  }
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 3.99"
  }
}

provider "azurerm" "management" {
  config {
    features {}
    tenant_id       = var.tenant_id
    subscription_id = var.subscription_id_management
    use_oidc        = true
    use_cli         = false
    use_msi         = false
    oidc_token      = var.identity_token
    client_id       = var.client_id
  }
}

component "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.4.0"
  inputs = {
    location                          = var.location
    resource_group_name               = "rg-management"
    linked_automation_account_enabled = false
    log_analytics_workspace_name      = var.log_analytics_workspace_name
    location                          = var.location
  }
}
