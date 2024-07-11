resource "aws_ecs_cluster" "main" {
  name = "ipfs-metadata-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole" # Update to the exact role name
}

resource "aws_ecs_task_definition" "ipfs_metadata_task" {
  family                   = "ipfs-metadata-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ipfs-metadata-container"
      image     = "amodkc/ipfs-metadata-server:latest"
      essential = true
      environment = [
        {
          name  = "POSTGRES_USER"
          value = var.postgres_user
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = var.postgres_password
        },
        {
          name  = "POSTGRES_DB"
          value = "testdb"
        },
        {
          name  = "POSTGRES_HOST"
          value = aws_db_instance.postgres.address
        },
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ipfs_metadata_service" {
  name            = "ipfs-metadata-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ipfs_metadata_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "ipfs-metadata-container"
    container_port   = 8080
  }
}
