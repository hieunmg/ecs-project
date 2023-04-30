variable "name" {
  type        = string
  description = "Name of the service"
}

variable "cluster_id" {
  type        = string
  description = "ID of the cluster"
}

variable "task_definition_arn" {
  type        = string
  description = "Full ARN of the task definition that you want to run in your service"
}

variable "launch_type" {
  type        = string
  description = "Launch type on which to run your service"
  validation {
    condition     = contains(["EC2", "FARGATE"], var.launch_type)
    error_message = "Valid values for launch_type are EC2, and FARGATE"
  }
}

variable "desired_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running"
  default     = 0
}

variable "scheduling_strategy" {
  type        = string
  description = "Scheduling strategy to use for the service"
  default     = "REPLICA"
  validation {
    condition     = contains(["REPLICA", "DAEMON"], var.scheduling_strategy)
    error_message = "Valid values for scheduling_strategy are REPLICA, and DAEMON"
  }
}

#----------------------------#
# Network configuration
#----------------------------#
variable "subnets_ids" {
  type        = set(string)
  description = "Subnets associated with the task or service"
}

variable "security_groups_ids" {
  type        = set(string)
  description = "Security groups associated with the task or service"
  default     = null
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether assign public IP address to the ENI"
  default     = false
}

#----------------------------#
# Load balancer attachment
#----------------------------#
variable "attach_load_balancer" {
  type        = bool
  description = "Whether to attach a load balancer to this service"
  default     = false
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the Load Balancer target group to associate with the service"
}

variable "container_name" {
  type        = string
  description = "Name of the container to associate with the load balancer"
}

variable "container_port" {
  type        = number
  description = "Port on the container to associate with the load balancer"
}
