variable "vpc_id" {
  type = string
}
variable "bastion_ip" {
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