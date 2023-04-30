variable "name_prefix" {
  type        = string
  description = "Name prefix for load balancer and load balancer listener"
}

variable "internal_lb" {
  type        = bool
  description = "Whether this load balancer is internal or internet-facing"
}

variable "subnets_id" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the LB"
}

variable "listener_port" {
  type        = number
  description = "Port on which load balancer listens on"
}

variable "listener_protocol" {
  type        = string
  description = "Protocol for connections from clients to the load balancer"
}

variable "target_vpc_id" {
  type        = string
  description = "ID of the VPC that this target group takes effect"
}

variable "target_port" {
  type        = number
  description = "Port on which load balancer listens on"
}

variable "target_protocol" {
  type        = string
  description = "Protocol for connections from clients to the load balancer"
}
