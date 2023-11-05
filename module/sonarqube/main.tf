#Creating SonarQube Server within an EC2 Instance
resource "aws_instance" "SonarQube_Server" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.sonarqube-sg]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = local.sonarqube_user_data

  tags = {
    Name = var.sonarQube_server
  }
}