
resource "aws_eks_access_entry" "bastion_access_entry" {
  cluster_name      = var.cluster_name
  principal_arn     = var.bastion_access_role_arn
  kubernetes_groups = ["masters"]
  type              = "STANDARD"

  tags = {
    Name = "eks-bastion-access"
  }
}