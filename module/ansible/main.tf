resource "aws_instance" "ansible_server" {
  ami                           = var.ami_redhat
  instance_type                 = var.instance_type
  subnet_id                     = var.subnet_id
  associate_public_ip_address  = true
  vpc_security_group_ids        = [var.bastion-ansible-sg]
  key_name                       = var.key_name
  user_data                     = local.ansible_user_data
  tags = {
    Name = var.tag-ansible
  }    
}