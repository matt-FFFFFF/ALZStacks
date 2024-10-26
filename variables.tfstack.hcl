variable "tenant_id" {
  type        = string
  description = "The tenant id UUID"
}

variable "subscription_id_management" {
  type        = string
  description = "The subscription id UUID for management resources"
}

variable "identity_token" {
  description = "The OIDC token for the identity."
  ephemeral   = true
  type        = string
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "The client id UUID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "The location for the resources"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the log analytics workspace"
}

variable "automation_account_name" {
  type        = string
  description = "The name of the automation account"
}
