variable "name" {
  type        = string
  description = "A unique name for your task definition"
}

variable "launch_types" {
  type        = set(string)
  description = "Set of launch types required by the task"

  validation {
    condition     = length(setintersection(var.launch_types, ["EC2", "FARGATE"])) > 0
    error_message = "Valid values for launch_types are EC2 and FARGATE"
  }
}

variable "network_mode" {
  type        = string
  description = "Docker networking mode to use for the containers in the task"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.network_mode)
    error_message = "Valid values for network_mode are none, bridge, awsvpc, and host"
  }
}

variable "memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
}

variable "cpu" {
  type        = number
  description = "Number of cpu units used by the task"
}

variable "container_definitions" {
  type = string
}