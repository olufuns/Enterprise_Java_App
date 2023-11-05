resource "aws_instance" "bastion" {
  ami                           = var.ami_redhat
  instance_type                 = var.instance_type
  subnet_id                     = var.subnet_id
  associate_public_ip_address  = true
  vpc_security_group_ids        = [var.bastion-ansible-sg]
  key_name                       = var.key_name
  user_data                     = <<-EOF
  #!/bin/bash
  echo "${var.private_keypair_path}" >> /home/ec2-user/keypair
  chmod 400 /home/ec2-user/keypair
  sudo hostnamectl set-hostname bastion
  EOF
  tags = {
    Name = var.tag-bastion
  }    
}