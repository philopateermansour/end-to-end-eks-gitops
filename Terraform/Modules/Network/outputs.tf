output "public-subnets" {
  value = [
    for subnet in aws_subnet.subnets :
    subnet.id if subnet.tags["Type"] == "public"
  ]
}
output "private-subnets" {
  value = [
    for subnet in aws_subnet.subnets :
    subnet.id if subnet.tags["Type"] == "private"
  ]
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}