output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
output "node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}
output "bastion_access_role_arn" {
  value = aws_iam_role.bastion_eks_access_role.arn
}
output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion_instance_profile.name
}
output "eks_cluster_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy_attachment
}
output "eks_vpc_resource_controller_attachment" {
  value = aws_iam_role_policy_attachment.eks_vpc_resource_controller_attachment
}
output "eks_worker_node_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_worker_node_policy_attachment
}
output "eks_cni_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cni_policy_attachment
}
output "ecr_read_only_policy_attachment" {
  value = aws_iam_role_policy_attachment.ecr_read_only_policy_attachment
}
output "ebs_csi_irsa_role_arn" {
  value = aws_iam_role.ebs_csi_irsa_role.arn
}
output "kaniko_role" {
  value = aws_iam_role.kaniko_ecr_push.arn
}
output "image_updater_role" {
  value = aws_iam_role.argocd_image_updater_role.arn
}
output "external_secrets_role" {
  value = aws_iam_role.external_secrets_role.arn
}