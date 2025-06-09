variable "ebs_csi_irsa_role_arn" {
  type = string
}
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
variable "ecr_frontend_repo_url" {
  type = string
}
variable "ecr_backend_repo_url" {
  type = string
}
variable "eks_cluster_token" {
  type = string
}