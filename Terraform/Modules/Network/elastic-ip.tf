resource "aws_eip" "nat_gw_ip" {
  tags ={
    Name = var.nat_gateway_eip_name
  }
}