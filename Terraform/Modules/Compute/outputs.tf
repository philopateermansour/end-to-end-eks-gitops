output "bastion_ip" {
  value = aws_instance.bastion_server.public_ip
}
