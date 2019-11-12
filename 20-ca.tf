#--------------------------------------------------------------
# CA
#--------------------------------------------------------------

resource "tls_private_key" "ca_key_pem" {
  algorithm = "${var.private_key_algorithm}"
  rsa_bits  = "${var.private_key_rsa_bits}"
}

resource "tls_self_signed_cert" "ca_cert_pem" {
  key_algorithm   = "${tls_private_key.ca_key_pem.algorithm}"
  private_key_pem = "${tls_private_key.ca_key_pem.private_key_pem}"

  subject {
    common_name  = "${var.ca_common_name}"
    organization = "${var.ca_organization_name}"
  }

  validity_period_hours = "${var.ca_validity_period_hours}"

  allowed_uses = [
    "${var.ca_allowed_uses}",
  ]

  dns_names    = "${var.ca_dns_names}"
  ip_addresses = "${var.ca_ip_addresses}"

  is_ca_certificate = true
}
