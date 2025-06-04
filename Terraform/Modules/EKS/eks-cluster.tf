resource "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name

  
  access_config {
    authentication_mode = "API"

    bootstrap_cluster_creator_admin_permissions = true
  }


  role_arn = var.eks_cluster_role_arn
  version  = var.cluster_version

  bootstrap_self_managed_addons = false


  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids         = var.private_subnets
    security_group_ids = [var.eks_cluster_sg_id]
  }

  depends_on = [
    var.eks_cluster_policy_attachment,
    var.eks_vpc_resource_controller_attachment,
  ]
}

data "aws_eks_cluster_auth" "cluster_token" {
  name = var.cluster_name
}

resource "aws_eks_addon" "eks_vpc_cni" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.19.2-eksbuild.1"

  resolve_conflicts_on_create = "OVERWRITE"

  tags = {
    Name = "eks-vpc-cni-addon"
  }


}
resource "aws_eks_addon" "eks_core_dns" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "coredns"
  addon_version = "v1.11.4-eksbuild.14"

  resolve_conflicts_on_create = "OVERWRITE"

  tags = {
    Name = "eks-coredns-addon"
  }

  depends_on = [
    aws_eks_node_group.default_node_group,
  ]

}
resource "aws_eks_addon" "eks_kube_proxy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "kube-proxy"
  addon_version = "v1.32.0-eksbuild.2"

  resolve_conflicts_on_create = "OVERWRITE"

  tags = {
    Name = "eks-kube-proxy-addon"
  }

}

