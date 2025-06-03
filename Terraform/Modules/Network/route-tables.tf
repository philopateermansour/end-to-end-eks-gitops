resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "public_associations" {
  for_each = {for subnet in local.subnets : subnet.name => subnet}
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = each.value.public ? aws_route_table.public_rt.id : aws_route_table.private_rt.id
}