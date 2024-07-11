
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = "ecs_task_execution_role"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
