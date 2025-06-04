resource "aws_instance" "bastion_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  iam_instance_profile        = var.bastion_instance_profile
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg]
  key_name                    = var.key_pair_name
  user_data                   = file("${path.module}/script.sh")

  tags = {
    Name = var.public_ec2_name
  }
}
