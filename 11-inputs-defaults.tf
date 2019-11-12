variable "ca_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the CA certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = "list"

  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

variable "ca_validity_period_hours" {
  default = "87600"
}

variable "ca_dns_names" {
  description = "List of DNS names for which the certificate will be valid (e.g. vault.service.consul, foo.example.com)."
  type        = "list"

  default = []
}

variable "ca_ip_addresses" {
  description = "List of IP addresses for which the certificate will be valid (e.g. 127.0.0.1)."
  type        = "list"

  default = []
}

variable "certificate_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = "list"

  default = [
    "key_encipherment",
    "digital_signature",
  ]
}

variable "certificate_validity_period_hours" {
  default = "87600"
}

variable "private_key_algorithm" {
  description = "The name of the algorithm to use for private keys. Must be one of: RSA or ECDSA."
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "The size of the generated RSA key in bits. Should only be used if var.private_key_algorithm is RSA."
  default     = "4096"
}
