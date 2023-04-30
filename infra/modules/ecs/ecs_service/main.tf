resource "aws_ecs_service" "hieunm_ecs_service" {
  name = var.name
  cluster = var.cluster_id

  task_definition = var.task_definition_arn
  launch_type = var.launch_type
  desired_count = var.desired_count
  scheduling_strategy = var.scheduling_strategy

  network_configuration {
    # security_groups = try()
    subnets          = var.subnets_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.attach_load_balancer ? [{
        target_group_arn = var.target_group_arn
        container_name = var.container_name
        container_port = var.container_port
    }] : []

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
}