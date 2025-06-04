resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Allow control plane to connect to nodes, node-to-node communication, SSH access from bastion, all outbound traffic from nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}
