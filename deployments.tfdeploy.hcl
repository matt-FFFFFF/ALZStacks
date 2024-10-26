identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}
deployment "prod" {
  inputs = {
    client_id                  = "45486b2f-bb91-48d1-864b-713851f058aa"
    identity_token             = identity_token.azure.jwt
    subscription_id_management = "e5b30252-0657-46bf-a8bc-4447918d7f99"
    location                   = "swedencentral"
  }
}
