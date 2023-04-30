backend_s3_bucket  = "hieunm-s3-backend"
backend_state_file = "infra-sit.tfstate"
backend_region     = "ap-southeast-1"

name_prefix       = "hieunm-sit"
internal_lb       = false
listener_port     = 8080
listener_protocol = "HTTP"
target_port       = 8080
target_protocol   = "HTTP"

task_definitions = {
  "go-backend" = {
    launch_types   = ["FARGATE"]
    network_mode   = "awsvpc"
    memory         = 2048
    cpu            = 1024
    container_name = "go-backend"
    container_port = 8080
    host_port      = 8080
  }
  "go-frontend" = {
    launch_types   = ["FARGATE"]
    network_mode   = "awsvpc"
    memory         = 4096
    cpu            = 2048
    container_name = "go-frontend"
    container_port = 3000
    host_port      = 3000
  }
}

ecs_services = {
  "go-backend" = {
    launch_type        = "FARGATE"
    task_definition    = "go-backend"
    desired_task_count = 1
    attach_lb          = true
    container_port     = 8080
  }
  "go-frontend" = {
    launch_type        = "FARGATE"
    task_definition    = "go-frontend"
    desired_task_count = 1
    attach_lb          = false
    container_port     = 3000
  }
}
