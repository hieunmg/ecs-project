resource "aws_lb" "load_balancer" {
  name               = format("%s-lb", var.name_prefix)
  internal           = var.internal_lb
  load_balancer_type = "application"
  subnets            = var.subnets_id

  tags = {
    Name = format("%s-lb", var.name_prefix)
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = format("%s-tg", var.name_prefix)
  target_type = "ip"
  protocol    = var.target_protocol
  port        = var.target_port
  vpc_id      = var.target_vpc_id

  health_check {
    healthy_threshold   = 2
    matcher             = "200-299"
    interval            = 10
    unhealthy_threshold = 2
  }

  tags = {
    Name = format("%s-tg", var.name_prefix)
  }
}
