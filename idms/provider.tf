provider "azurerm" {
  features {
  }
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
  resource_provider_registrations = "none"
  subscription_id                 = "b876779a-6ccf-475f-8ea1-d1a829aab943"
}
