variable "keyvaultaddon_config" {
  type = object({
    key_name                       = string
    key_type                       = string
    key_size                       = number
    key_opts                       = list(string)
    secret_name                    = string
    secret_value                   = string
    certificate_name               = string
    certificate_issuer_name        = string
    certificate_exportable         = bool
    certificate_key_size           = number
    certificate_key_type           = string
    certificate_reuse_key          = bool
    certificate_content_type       = string
    certificate_subject            = string
    certificate_validity_in_months = number
    certificate_key_usage          = list(string)
    keyvault_config = object({
      environment = string
      owner       = string
    })
    keyvault_id = string
  })

  default = {
    key_name                       = ""
    key_type                       = "RSA"
    key_size                       = 2048
    key_opts                       = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]
    secret_name                    = ""
    secret_value                   = ""
    certificate_name               = ""
    certificate_issuer_name        = "Self"
    certificate_exportable         = true
    certificate_key_size           = 2048
    certificate_key_type           = "RSA"
    certificate_reuse_key          = true
    certificate_content_type       = "application/x-pkcs12"
    certificate_subject            = ""
    certificate_validity_in_months = 12
    certificate_key_usage          = ["digitalSignature", "keyEncipherment"]
    keyvault_config = {
      environment = "dev"
      owner       = "admin"
    }
    keyvault_id = ""
  }
}

output "keyvault_id" {
  description = "The ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}