# creating LB Target group
resource "aws_lb_target_group" "target_group_prod" {
  name     = var.prod_tg_name
  port     = var.port_proxy
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

#creating Prod application load balancer
resource "aws_lb" "prod-alb" {
  name               = var.prod_alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.prod_security_group
  subnets            = var.prod_subnet_id
  enable_deletion_protection = false
  tags = {
    Name = var.tag-prod-alb
  }
}

#Creating Load balancer listener for HTTP
resource "aws_lb_listener" "prod-http" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = var.http_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_prod.arn
  }
}

#Creating prod Load balancer listener for HTTPs
resource "aws_lb_listener" "https-prod" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_prod.arn
  }
}