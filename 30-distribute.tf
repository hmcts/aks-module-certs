#--------------------------------------------------------------
# Distribute Certificates
#--------------------------------------------------------------

resource "azurerm_key_vault_secret" "ca_key_pem" {
  name      = "${var.ca_common_name}-ca-key-pem-${var.deploy_environment}"
  value     = "${tls_private_key.ca_key_pem.private_key_pem}"
  vault_uri = "https://${var.azure_key_vault}.vault.azure.net/"
}

resource "azurerm_key_vault_secret" "ca_cert_pem" {
  name      = "${var.ca_common_name}-ca-cert-pem-${var.deploy_environment}"
  value     = "${tls_self_signed_cert.ca_cert_pem.cert_pem}"
  vault_uri = "https://${var.azure_key_vault}.vault.azure.net/"
}

resource "azurerm_key_vault_secret" "certificate_key_pem" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  name = "${element(
                keys(var.certificates),
                count.index
            )}-certificate-key-pem-${var.deploy_environment}"

  value = "${element(
        tls_private_key.certificate_key_pem.*.private_key_pem,
        (count.index % length(var.certificates))
    )}"

  vault_uri = "https://${var.azure_key_vault}.vault.azure.net/"
}

resource "azurerm_key_vault_secret" "certificate_csr_pem" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  name = "${element(
                keys(var.certificates),
                count.index
            )}-certificate-csr-pem-${var.deploy_environment}"

  value = "${element(
        tls_cert_request.certificate_csr_pem.*.cert_request_pem,
        (count.index % length(var.certificates))
    )}"

  vault_uri = "https://${var.azure_key_vault}.vault.azure.net/"
}

resource "azurerm_key_vault_secret" "certificate_cert_pem" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  name = "${element(
                keys(var.certificates),
                count.index
            )}-certificate-cert-pem-${var.deploy_environment}"

  value = "${element(
        tls_locally_signed_cert.certificate_cert.*.cert_pem,
        (count.index % length(var.certificates))
    )}"

  vault_uri = "https://${var.azure_key_vault}.vault.azure.net/"
}
