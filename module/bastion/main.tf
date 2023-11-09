resource "aws_instance" "bastion" {
  ami                           = var.ami_redhat
  instance_type                 = var.instance_type
  subnet_id                     = var.subnet_id
  associate_public_ip_address  = true
  vpc_security_group_ids        = [var.bastion-ansible-sg]
  key_name                       = var.key_name
  user_data                     = <<-EOF
  #!/bin/bash
  echo "pubkeyAcceptedkeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
  systemctl reload sshd
  echo "${var.private_keypair_path}" >> /home/ec2-user/.ssh/id_rsa
  chown ec2-user /home/ec2-user/.ssh/id_rsa
  chgrp ec2-user /home/ec2-user/.ssh/id_rsa
  chmod 600 /home/ec2-user/.ssh/id_rsa
  sudo hostnamectl set-hostname Bastion
  #!/bin/bash
  EOF
  tags = {
    Name = var.tag-bastion
  }    
}