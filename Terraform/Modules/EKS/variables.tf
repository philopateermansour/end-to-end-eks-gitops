variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "private_subnets" {
  type = list(string)
}
variable "eks_cluster_role_arn" {
  type = string
}
variable "node_role_arn" {
  type = string
}
variable "eks_cluster_sg_id" {
  type = string
}
variable "eks_node_sg_id" {
  type = string
}
variable "key_pair_name" {
  type = string 
}
variable "eks_cluster_policy_attachment" {
  type = object({
    id = string
    policy_arn = string
    role = string 
  })
}
variable "eks_vpc_resource_controller_attachment" {
  type = object({
    id = string
    policy_arn = string
    role = string 
  })
}
variable "eks_worker_node_policy_attachment" {
  type = object({
    id = string
    policy_arn = string
    role = string 
  })
}
variable "eks_cni_policy_attachment" {
  type = object({
    id = string
    policy_arn = string
    role = string 
  })
}
variable "ecr_read_only_policy_attachment" {
  type = object({
    id = string
    policy_arn = string
    role = string 
  })
}