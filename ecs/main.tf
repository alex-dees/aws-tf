resource "aws_ecr_repository" "repo" {
  name = "nginx"
}

resource "aws_ecs_cluster" "cluster" {
  name = "main"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "nginx-service"
}

resource "aws_ecs_task_definition" "task-def" {
  family = "nginx-tasks"
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.task-exec-role.arn
  container_definitions = jsonencode([{
    name = "nginx"
    image = "844540003076.dkr.ecr.us-east-1.amazonaws.com/nginx"
    essential = true
    logConfiguration = {
        logDriver = "awslogs"
        options = {
            awslogs-region = var.region
            awslogs-group = aws_cloudwatch_log_group.log-group.name
            awslogs-stream-prefix = "test"
        }
    }
    portMappings = [{
        hostPort = 80
        containerPort = 80
    }]
  }])
}

resource "aws_ecs_service" "service" {
  name = "nginx"
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task-def.arn
  network_configuration {
    subnets = [aws_subnet.private.id]
  }
}
