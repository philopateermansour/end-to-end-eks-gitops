locals {
  public_subnet_cidrs  = [for i in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnet_cidrs = [for i in range(length(var.azs), 2 * length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i)]



  subnets = flatten([
    [for i in range(length(var.azs)) : {
      name       = "public-subnet-${i + 1}"
      cidr_block = local.public_subnet_cidrs[i]
      az         = var.azs[i]
      public     = true
    }],
    [for i in range(length(var.azs)) : {
      name       = "private-subnet-${i + 1}"
      cidr_block = local.private_subnet_cidrs[i]
      az         = var.azs[i]
      public     = false
    }]
  ])

}

resource "aws_subnet" "subnets" {
  for_each                = { for subnet in local.subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public ? true : false

  tags = {
    Name = each.value.name
    Type = each.value.public ? "public" : "private"
  }
}