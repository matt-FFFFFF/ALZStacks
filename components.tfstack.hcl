required_providers {
  alz = {
    source  = "Azure/alz"
    version = "~> 0.15"
  }
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
  time = {
    source  = "hashicorp/time"
    version = "~> 0.9"
  }
}

provider "alz" "prod" {
  config {
    oidc_request_token = var.identity_token
    tenant_id          = var.tenant_id
    client_id          = var.client_id
    use_cli            = false
    use_msi            = false
    use_oidc           = true
    library_references = [{
      # Local ref doesn't work in TF Cloud, maybe it doesn't get uploaded in the bundle?
      custom_url = "git::https://github.com/matt-FFFFFF/ALZStacks//alzlibrary?ref=main"
    }]
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

provider "azapi" "alz" {
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

provider "time" "all" {
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

component "alz" {
  source = "git::https://github.com/Azure/terraform-azurerm-avm-ptn-alz.git?ref=stacks"
  providers = {
    alz    = provider.alz.prod
    azapi  = provider.azapi.alz
    modtm  = provider.modtm.all
    random = provider.random.all
    time   = provider.time.all
  }
  inputs = {
    architecture_name  = "mattffffff-alz"
    location           = var.location
    parent_resource_id = var.tenant_id
    policy_default_values = {
      ama_user_assigned_managed_identity_name = basename(component.alz_management.user_assigned_identity_ids.ama)
    }
  }
}
