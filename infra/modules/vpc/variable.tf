variable "cidr" {
  type = string
}

variable "name_prefix" {
  type        = string
  description = "Name prefix applied to all components in this VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of AZs that this VPC actually owns resources on"
}

#----------------------------#
# NAT Gateway
#----------------------------#
variable "enable_nat_gateway" {
  type        = bool
  description = "Whether create NAT Gateway in this VPC"
}

variable "one_nat_gateway_per_subnet" {
  type        = bool
  description = "Whether create only one NAT Gateway per subnet"
}

#----------------------------#
# Subnet
#----------------------------#
variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

#----------------------------#
# Route tables
#----------------------------#
# variable "public_route_tabe" {

# }

#----------------------------#
# Default Security Group
#----------------------------#
variable "default_security_group_ingress" {
  type = map(object({
    protocol    = string
    from_port   = string
    to_port     = string
    cidr_blocks = list(string)
  }))
}

variable "default_security_group_egress" {
  type = map(object({
    protocol    = string
    from_port   = string
    to_port     = string
    cidr_blocks = list(string)
  }))
}