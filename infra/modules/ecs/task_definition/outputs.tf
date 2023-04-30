output "id" {
  value = aws_ecs_task_definition.hieunm_ecs_task_definition.id
}

output "full_arn" {
  value = aws_ecs_task_definition.hieunm_ecs_task_definition.arn
}

output "arn_without_revision" {
  value = aws_ecs_task_definition.hieunm_ecs_task_definition.arn_without_revision
}

output "name" {
  value = aws_ecs_task_definition.hieunm_ecs_task_definition.family
}
