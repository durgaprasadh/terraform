resource "aws_lb" "lb-application" {
  load_balancer_type = "application"
  name            = "express-lb"
  subnets         = ["subnet-7d355e35", "subnet-e14cd487","subnet-1772a84d"]
  security_groups = [aws_security_group.express_task.id]
}

resource "aws_lb_target_group" "express_task" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-8283ace4"
  target_type = "ip"
}

resource "aws_lb_listener" "express_task" {
  load_balancer_arn = aws_lb.lb-application.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.express_task.id
    type             = "forward"
  }
}
