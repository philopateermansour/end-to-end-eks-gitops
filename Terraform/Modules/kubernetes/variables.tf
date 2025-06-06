variable "cluster_endpoint" {
  type = string
}
variable "cluster_ca_certificate" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "region" {
  type = string
}
variable "kaniko_role" {
  type = string
}

variable "grafana_admin_user" {
  type      = string
  sensitive = true
}
variable "grafana_admin_password" {
  type      = string
  sensitive = true
}
variable "image_updater_role" {
  type = string
}
variable "external_secrets_role" {
  type = string
}