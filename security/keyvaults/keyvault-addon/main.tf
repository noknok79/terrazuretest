provider "azurerm" {
  features {}
  subscription_id            = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id                  = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true

}

resource "azurerm_key_vault_key" "additional_keys" {
  name         = var.key_name
  key_vault_id = var.keyvault_id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = var.key_opts
  tags = {
    environment = var.keyvault_config.environment
    owner       = var.keyvault_config.owner
  }
}

resource "azurerm_key_vault_secret" "additional_secrets" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = var.keyvault_id
  tags = {
    environment = var.keyvault_config.environment
    owner       = var.keyvault_config.owner
  }
}

resource "azurerm_key_vault_certificate" "additional_certificates" {
  name         = var.certificate_name
  key_vault_id = var.keyvault_id
  certificate_policy {
    issuer_parameters {
      name = "Self"
    }
    key_properties {
      exportable = var.certificate_key_exportable
      key_size   = var.certificate_key_size
      key_type   = var.certificate_key_type
      reuse_key  = var.certificate_key_reuse
    }
    secret_properties {
      content_type = "application/x-pkcs12"
    }
    x509_certificate_properties {
      subject            = var.certificate_subject
      validity_in_months = var.certificate_validity_in_months
      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]
    }
  }
  tags = {
    environment = var.keyvault_config.environment
    owner       = var.keyvault_config.owner
  }
}

# variable "key_vault_id" {
#   description = "The ID of the Key Vault where the add-ons will be created."
#   type        = string
#   default     = "your-keyvault-id"
# }

variable "key_name" {
  description = "The name of the Key Vault key."
  type        = string
  default     = "1st-addons-key"
}

variable "key_type" {
  description = "The type of the Key Vault key."
  type        = string
  default     = "RSA"
}

variable "key_size" {
  description = "The size of the Key Vault key."
  type        = number
  default     = 2048
}

variable "key_opts" {
  description = "The operations allowed for the Key Vault key."
  type        = list(string)
  default     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]
}

variable "secret_name" {
  description = "The name of the Key Vault secret."
  type        = string
  default     = "1st-addons-secret"
}

variable "secret_value" {
  description = "The value of the Key Vault secret."
  type        = string
  default     = "my-secret-value"
}

variable "certificate_name" {
  description = "The name of the Key Vault certificate."
  type        = string
  default     = "1st-addons-certificate"
}

variable "certificate_issuer_name" {
  description = "The issuer name for the certificate."
  type        = string
  default     = "Self"
}

variable "certificate_key_exportable" {
  description = "Whether the certificate key is exportable."
  type        = bool
  default     = true
}

variable "certificate_key_size" {
  description = "The size of the certificate key."
  type        = number
  default     = 2048
}

variable "certificate_key_type" {
  description = "The type of the certificate key."
  type        = string
  default     = "RSA"
}

variable "certificate_key_reuse" {
  description = "Whether the certificate key should be reused."
  type        = bool
  default     = true
}

variable "certificate_content_type" {
  description = "The content type of the certificate secret."
  type        = string
  default     = "application/x-pkcs12"
}

variable "certificate_subject" {
  description = "The subject of the certificate."
  type        = string
  default     = "CN=example.com"
}

variable "certificate_validity_in_months" {
  description = "The validity period of the certificate in months."
  type        = number
  default     = 12
}

variable "certificate_key_usage" {
  description = "The key usage for the certificate."
  type        = list(string)
  default     = ["digitalSignature", "keyEncipherment"]
}

variable "keyvault_config" {
  description = "Configuration for the Key Vault, including environment and owner tags."
  type = object({
    environment = string
    owner       = string
  })
  default = {
    environment = "dev"
    owner       = "admin"
  }
}

variable "keyvault_id" {
  description = "The ID of the Key Vault."
  type        = string
}