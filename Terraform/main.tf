module "Network" {
  source                   = "./Modules/Network"
  vpc_name                 = var.vpc_name
  vpc_cidr                 = var.vpc_cidr
  azs                      = var.azs
  internet_gw_name         = var.internet_gw_name
  nat_gw_name              = var.nat_gw_name
  nat_gateway_eip_name     = var.nat_gateway_eip_name
  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name
}
module "Compute" {
  source                   = "./Modules/Compute"
  public_subnet_id         = module.Network.public-subnets[0]
  bastion_sg               = module.Secuiry.bastion_sg_id
  instance_ami             = var.instance_ami
  instance_type            = var.instance_type
  public_ec2_name          = var.public_ec2_name
  bastion_instance_profile = module.Identity.bastion_instance_profile
  key_pair_name            = module.Secuiry.key_pair_name
  cluster_name             = module.EKS.cluster_name
  bastion_access_role_arn  = module.Identity.bastion_access_role_arn
  cluster_endpoint         = module.EKS.cluster_endpoint
  cluster_ca_certificate   = module.EKS.cluster_ca_certificate
  region                   = var.region
}
module "Secuiry" {
  source     = "./Modules/Security"
  vpc_id     = module.Network.vpc_id
  bastion_ip = module.Compute.bastion_ip
  mysql_user_password = var.mysql_user_password
  mysql_root_password = var.mysql_root_password
  redis_password       = var.redis_password
}
module "ECR" {
  source         = "./Modules/ECR"
  front_ecr_name = var.front_ecr_name
  back_ecr_name  = var.back_ecr_name
}
module "EKS" {
  source                                 = "./Modules/EKS"
  cluster_name                           = var.cluster_name
  cluster_version                        = var.cluster_version
  private_subnets                        = module.Network.private-subnets
  eks_cluster_role_arn                   = module.Identity.eks_cluster_role_arn
  node_role_arn                          = module.Identity.node_role_arn
  eks_cluster_sg_id                      = module.Secuiry.eks_cluster_sg_id
  eks_node_sg_id                         = module.Secuiry.eks_node_sg_id
  key_pair_name                          = module.Secuiry.key_pair_name
  eks_cluster_policy_attachment          = module.Identity.eks_cluster_policy_attachment
  eks_vpc_resource_controller_attachment = module.Identity.eks_vpc_resource_controller_attachment
  eks_worker_node_policy_attachment      = module.Identity.eks_worker_node_policy_attachment
  eks_cni_policy_attachment              = module.Identity.eks_cni_policy_attachment
  ecr_read_only_policy_attachment        = module.Identity.ecr_read_only_policy_attachment
}

module "Identity" {
  source      = "./Modules/Identity"
  cluster_url = module.EKS.cluster_url
}
module "Helm" {
  source                 = "./Modules/Helm"
  ebs_csi_irsa_role_arn  = module.Identity.ebs_csi_irsa_role_arn
  cluster_endpoint       = module.EKS.cluster_endpoint
  cluster_ca_certificate = module.EKS.cluster_ca_certificate
  cluster_name           = module.EKS.cluster_name
  region                 = var.region
  ecr_frontend_repo_url  = module.ECR.ecr_frontend_repo_url
  ecr_backend_repo_url   = module.ECR.ecr_backend_repo_url
  eks_cluster_token      = module.EKS.eks_cluster_token

}
module "kubernetes" {
  source                 = "./Modules/kubernetes"
  cluster_endpoint       = module.EKS.cluster_endpoint
  cluster_ca_certificate = module.EKS.cluster_ca_certificate
  cluster_name           = module.EKS.cluster_name
  region                 = var.region
  kaniko_role            = module.Identity.kaniko_role
  grafana_admin_user     = var.grafana_admin_user
  grafana_admin_password = var.grafana_admin_password
  image_updater_role     = module.Identity.image_updater_role
  external_secrets_role  = module.Identity.external_secrets_role

}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --profile ${var.profile} --region ${var.region} --name ${module.EKS.cluster_name}"
  }
}

resource "null_resource" "push-images" {
  provisioner "local-exec" {
    command = <<END
    aws ecr get-login-password --profile ${var.profile} --region ${var.region} | docker login --username AWS --password-stdin ${module.ECR.registry_url}
    docker tag frontend:latest ${module.ECR.ecr_frontend_repo_url}:v1.0
    docker tag backend:latest ${module.ECR.ecr_backend_repo_url}:v1.0
    docker push ${module.ECR.ecr_frontend_repo_url}:v1.0
    docker push ${module.ECR.ecr_backend_repo_url}:v1.0
    END
  }
}
