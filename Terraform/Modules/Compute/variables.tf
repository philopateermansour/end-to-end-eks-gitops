variable "instance_ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "public_subnet_id" {
  type = string
}
variable "bastion_sg" {
  type = string
}
variable "public_ec2_name" {
  type = string
}
variable "bastion_instance_profile" {
  type = string
}
variable "key_pair_name" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "bastion_access_role_arn" {
  type = string
}
variable "cluster_endpoint" {
  type = string
}
variable "cluster_ca_certificate" {
  type = string
}
variable "region" {
  type = string
}