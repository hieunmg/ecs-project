cidr = "10.0.0.0/24"

name_prefix = "hieunm-sit"

public_subnets  = ["10.0.0.0/28", "10.0.0.32/28"]
private_subnets = ["10.0.0.16/28", "10.0.0.48/28"]

default_security_group_ingress = {
  "ingressRule1" = {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
default_security_group_egress = {
  "egressRule1" = {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}