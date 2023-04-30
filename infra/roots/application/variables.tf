#-------------------------------#
# VPC backend's configuration
#-------------------------------#
variable "backend_s3_bucket" {
  type = string
}

variable "backend_state_file" {
  type = string
}

variable "backend_region" {
  type = string
}

#-------------------------------#
# General information
#-------------------------------#
variable "name_prefix" {
  type        = string
  description = "Prefix for name of all resources"
}

#-------------------------------#
# Backend's load balancer
#-------------------------------#
variable "internal_lb" {
  type        = bool
  description = "Whether this load balancer is internal or internet-facing"
}

variable "listener_port" {
  type        = number
  description = "Port on which load balancer listens on"
}

variable "listener_protocol" {
  type        = string
  description = "Protocol for connections from clients to the load balancer"
}

variable "target_port" {
  type        = number
  description = "Port on which load balancer listens on"
}

variable "target_protocol" {
  type        = string
  description = "Protocol for connections from clients to the load balancer"
}

#-------------------------------#
# Task defintion
#-------------------------------#
variable "task_definitions" {
  type = map(object({
    launch_types   = set(string)
    network_mode   = string
    memory         = number
    cpu            = number
    container_name = string
    container_port = number
    host_port      = number
  }))
}

variable "backend_container_image_url" {
  type = string
}

variable "frontend_container_image_url" {
  type = string
}

#-------------------------------#
# ECS service
#-------------------------------#
variable "ecs_services" {
  type = map(object({
    launch_type        = string
    task_definition    = string
    desired_task_count = number
    attach_lb          = bool
    container_port     = number
  }))
}