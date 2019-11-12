variable "azure_key_vault" {}
variable "deploy_environment" {}

variable "ca_common_name" {}
variable "ca_organization_name" {}

variable "certificates" {
  type = "map"

  default = {}
}
