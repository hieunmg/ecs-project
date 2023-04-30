data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.backend_s3_bucket
    key    = var.backend_state_file
    region = var.backend_region
    profile = "hieunm"
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id
  public_subnets_ids = [
    for key, public_subnet in data.terraform_remote_state.vpc.outputs.public_subnets : public_subnet.id
  ]
  private_subnets_ids = [
    for key, private_subnet in data.terraform_remote_state.vpc.outputs.private_subnets : private_subnet.id
  ]
}

module "ecs_cluster" {
  source = "../../modules/ecs"

  name = format("%s-go-cluster", var.name_prefix)
}

module "ecs_task_definition" {
  source   = "../../modules/ecs/task_definition"
  for_each = var.task_definitions

  name         = format("%s-%s", var.name_prefix, each.key)
  launch_types = each.value.launch_types
  network_mode = each.value.network_mode

  memory = each.value.memory
  cpu    = each.value.cpu

  container_definitions = jsonencode([
    {
      name      = each.value.container_name
      image     = each.key != "go-frontend" ? var.backend_container_image_url : var.frontend_container_image_url
      memory    = each.value.memory
      cpu       = each.value.cpu
      essential = true
      portMappings = [{
        containerPort = each.value.container_port
        hostPort      = each.value.host_port
      }]
      environment = each.key != "go-frontend" ? null : [
        {
          name = "REACT_APP_ALB_ADDRESS"
          value = format("http://%s:%d", module.backend_alb.dns_name, 8080)
        }
      ]
    }
  ])
}

module "backend_alb" {
  source = "../../modules/loadbalancer/alb"

  name_prefix       = var.name_prefix
  subnets_id        = local.public_subnets_ids
  internal_lb       = var.internal_lb
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
  target_vpc_id     = local.vpc_id
  target_port       = var.target_port
  target_protocol   = var.target_protocol
}

module "ecs_service" {
  source   = "../../modules/ecs/ecs_service"
  for_each = var.ecs_services

  name       = each.key
  cluster_id = module.ecs_cluster.id

  task_definition_arn = lookup(module.ecs_task_definition, each.value.task_definition, null).full_arn
  launch_type         = each.value.launch_type
  desired_count       = each.value.desired_task_count

  subnets_ids = each.key == "go-frontend" ? local.public_subnets_ids : local.private_subnets_ids
  assign_public_ip = each.key == "go-frontend" ? true : false

  attach_load_balancer = each.value.attach_lb
  target_group_arn     = module.backend_alb.target_group_arn
  container_name       = lookup(var.task_definitions, each.value.task_definition, null).container_name
  container_port       = each.value.container_port
}