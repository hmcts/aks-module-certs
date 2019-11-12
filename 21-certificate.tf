#--------------------------------------------------------------
# Certificate
#--------------------------------------------------------------

## create certificates from a map, whose values are colon seperated strings
## this list defaults to {}
## each certificate map key/value pair should have the format:
## <certificate_identifier>: "<certificate_common_name>:<certificate_organization>"
## eg:  variable "certificates" {
##          type = "map"
##          default = {
##              tiller = "hmcts:ssaks"
##          }
##      }

resource "tls_private_key" "certificate_key_pem" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  algorithm = "${var.private_key_algorithm}"
  rsa_bits  = "${var.private_key_rsa_bits}"
}

resource "tls_cert_request" "certificate_csr_pem" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  key_algorithm = "${element(
        tls_private_key.certificate_key_pem.*.algorithm,
        (count.index % length(var.certificates))
    )}"

  private_key_pem = "${element(
        tls_private_key.certificate_key_pem.*.private_key_pem,
        (count.index % length(var.certificates))
    )}"

  "subject" {
    common_name = "${element(
        split(":",
            element(
                values(var.certificates),
                count.index
            )
        ),
        0
    )}"

    organization = "${element(
        split(":",
            element(
                values(var.certificates),
                count.index
            )
        ),
        1
    )}"
  }
}

resource "tls_locally_signed_cert" "certificate_cert" {
  count = "${(var.certificate_required == "true" ? 1 : 0) * length(var.certificates)}"

  cert_request_pem = "${element(
        tls_cert_request.certificate_csr_pem.*.cert_request_pem,
        (count.index % length(var.certificates))
    )}"

  ca_key_algorithm   = "${tls_private_key.ca_key_pem.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key_pem.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca_cert_pem.cert_pem}"

  validity_period_hours = "${var.certificate_validity_period_hours}"

  allowed_uses = [
    "${var.certificate_allowed_uses}",
  ]

  depends_on = [
    "tls_private_key.ca_key_pem",
    "tls_self_signed_cert.ca_cert_pem",
  ]
}
