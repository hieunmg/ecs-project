variable "cidr" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

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