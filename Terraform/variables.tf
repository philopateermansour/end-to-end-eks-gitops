variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
 type = string 
}
variable "azs" {
  type = list(string)
}
variable "internet_gw_name" {
  type = string
}
variable "nat_gw_name" {
  type = string
}
variable "nat_gateway_eip_name" {
  type = string
}
variable "public_route_table_name" {
  type = string
}
variable "private_route_table_name" {
  type = string
}
variable "instance_ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "public_ec2_name" {
  type = string
}
variable "front_ecr_name" {
  type = string
}
variable "back_ecr_name" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_version" {
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
variable "region" {
  type = string
}
variable "profile" {
  type = string
}
variable "mysql_user_password" {
  type      = string
  sensitive = true
}
variable "mysql_root_password" {
  type      = string
  sensitive = true
}
variable "redis_password" {
  type      = string
  sensitive = true
}