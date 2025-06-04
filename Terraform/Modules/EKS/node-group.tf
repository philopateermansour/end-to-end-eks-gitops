resource "aws_eks_node_group" "default_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-default-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]

  remote_access {
    ec2_ssh_key               = var.key_pair_name
    source_security_group_ids = [var.eks_node_sg_id]
  }


  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }


  depends_on = [
    aws_eks_cluster.eks_cluster,
    var.eks_worker_node_policy_attachment,
    var.eks_cni_policy_attachment,
    var.ecr_read_only_policy_attachment,
  ]


  tags = {
    Name = "eks-default-nodegroup"
  }
}


