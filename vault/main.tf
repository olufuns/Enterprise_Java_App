locals {
  name = "pacaadpet"
}

#aws provider
provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

# Security Group for vault Server
resource "aws_security_group" "vault_sg-6" {
  name        = "vault"
  description = "Allow inbound traffic"
  
  ingress {
    description = "SSH access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = var.sg-protocol
    cidr_blocks = [var.cidr-all]
  }

  ingress {
    description = "port_vault"
    from_port   = var.port_vault
    to_port     = var.port_vault
    protocol    = var.sg-protocol
    cidr_blocks = [var.cidr-all]
  }
  
  ingress {
    description = "HTTP access"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = var.sg-protocol
    cidr_blocks = [var.cidr-all]
  }
  
  ingress {
    description = "HTTPS access"
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = var.sg-protocol
    cidr_blocks = [var.cidr-all]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  }
  
  tags = {
    Name = "${local.name}-vault_sg"
  }
}

#vault instance
resource "aws_instance" "vault-server" {
  ami                         = var.vault-ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.vault_sg-6.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vault_key_pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.id
  user_data                   = templatefile("./vault-script.sh",{
    domain_name = var.domain_name,
    email = var.email,
    aws_region = var.aws_region,
    kms_key = aws_kms_key.vault6.id,
    api_key = var.api_key,
    account_id = var.account_id
  })
  tags = {
    name = "${local.name}-vault-server"
  }
}

#kms key for vault
resource "aws_kms_key" "vault6" {
  description             = "vault unseal key"
  deletion_window_in_days = 10
  
  tags = {
    name = "${local.name}-kms-key-vault-server"
  }
}

# Route 53 hosted zone
data "aws_route53_zone" "vault" {
  name         = var.domain_name
  private_zone = false
}

#Create route 53 A record
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.vault.zone_id
  name    = var.domain_name
  type    = "A"
  records = [aws_instance.vault-server.public_ip]
  ttl = 300
}

#creating keypair
resource "tls_private_key" "vault_keypair" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

#create local file for private keypair
resource "local_file" "vault_keypair" {
  content  = tls_private_key.vault_keypair.private_key_pem
  filename = "vault_keypair.pem"
  file_permission = "600"
}

#creating public key resources
resource "aws_key_pair" "vault_key_pair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.vault_keypair.public_key_openssh
}