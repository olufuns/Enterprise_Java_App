resource "aws_instance" "Jenkins_Server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.prt_subnet
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group
  key_name                    = var.key_name
  user_data                   = local.jenkins_user_data
  tags = {
    Name = var.tag-jenkins-server
  }
}

# Create Jenkins load balancer
resource "aws_elb" "lb" {
  name                = var.jenkins-elb
  subnets             = var.subnet-id
  security_groups     = var.security_group

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # listener {
  #   instance_port      = 8000
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [aws_instance.Jenkins_Server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.jenkins-elb
  }
}