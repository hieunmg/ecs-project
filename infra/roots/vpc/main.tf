data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"
  cidr        = var.cidr
  name_prefix  = var.name_prefix
  azs         = data.aws_availability_zones.available.names

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway         = true
  one_nat_gateway_per_subnet = false

  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress
}