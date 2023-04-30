resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  tags = {
    Name = format("%s-vpc", var.name_prefix)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-igw", var.name_prefix)
  }
}

#----------------------------#
# NAT Gateway
#----------------------------#
locals {
  number_of_nats = var.one_nat_gateway_per_subnet ? length(var.public_subnets) : 1
}

resource "aws_eip" "nat" {
  count = local.number_of_nats

  vpc = true
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.number_of_nats : 0

  allocation_id = element(aws_eip.nat[*].allocation_id, count.index)
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("%s-ngw-%d", var.name_prefix, count.index)
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

#----------------------------#
# Public Subnet
#----------------------------#
locals {
  public_subnets = {
    for i in range(0, length(var.public_subnets), 1) : i => var.public_subnets[i]
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, each.key % length(var.azs))
  cidr_block        = each.value

  tags = {
    Name = format("%s-public-subnet-%d", var.name_prefix, each.key)
  }
}

resource "aws_route_table" "public" {
  # only create public RTB if there's at least 1 public subnet
  count = length(local.public_subnets) != 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = format("%s-public-rtb", var.name_prefix)
  }
}

resource "aws_route_table_association" "public" {
  count = length(local.public_subnets)

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

#----------------------------#
# Private Subnet
#----------------------------#
locals {
  private_subnets = {
    for i in range(0, length(var.private_subnets), 1) : i => var.private_subnets[i]
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, each.key % length(var.azs))
  cidr_block        = each.value

  tags = {
    Name = format("%s-private-subnet-%d", var.name_prefix, each.key)
  }
}

resource "aws_route_table" "private" {
  count = length(local.private_subnets)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this[*].id, count.index % length(aws_nat_gateway.this))
  }

  tags = {
    Name = format("%s-private-rtb-%d", var.name_prefix, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)

  route_table_id = element(aws_route_table.private[*].id, count.index)
  subnet_id      = aws_subnet.private[count.index].id
}

#----------------------------#
# Default Security Group
#----------------------------#
resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress

    content {
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress

    content {
      protocol    = egress.value.protocol
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = format("%s-default-sg", var.name_prefix)
  }
}