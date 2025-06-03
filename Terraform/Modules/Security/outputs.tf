output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}
output "key_pair_name" {
  value = aws_key_pair.sshkeypair.key_name
}
