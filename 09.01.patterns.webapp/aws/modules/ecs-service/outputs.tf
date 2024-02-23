

output "ecs_service_name" {
  value = aws_ecs_service.ecs-service[*].name
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

