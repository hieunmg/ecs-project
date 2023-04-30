resource "aws_ecs_task_definition" "hieunm_ecs_task_definition" {
  family                   = var.name
  requires_compatibilities = var.launch_types
  network_mode             = var.network_mode

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  memory = var.memory
  cpu    = var.cpu

  container_definitions = var.container_definitions
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
	{
		"Version": "2012-10-17",
		"Statement": [
			{
				"Sid": "",
				"Effect": "Allow",
				"Principal": {
					"Service": "ecs-tasks.amazonaws.com"
				},
				"Action": "sts:AssumeRole"
			}
		]
	}
	EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
	