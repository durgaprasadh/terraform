resource "aws_ecs_cluster" "main" {
  name = "express-cluster"
}

resource "aws_ecs_service" "express" {
  name            = "express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ECS-Task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.express_task.id]
    subnets         = ["subnet-7d355e35", "subnet-e14cd487","subnet-1772a84d"]
	assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_task.id
    container_name   = "express-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.express_task]
}

resource "aws_security_group" "express_task" {
  name        = "express-task-security-group"
  vpc_id      = "vpc-8283ace4"

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "ECS-Task" {
  family                   = "ECS"
  execution_role_arn       =  "arn:aws:iam::191436313339:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = <<DEFINITION
[
  {
    "image": "191436313339.dkr.ecr.eu-west-1.amazonaws.com/devops-interview",
    "cpu": 256,
    "memory": 512,
    "name": "express-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}
