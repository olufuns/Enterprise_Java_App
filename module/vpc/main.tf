# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = var.tag-vpc
  }
}
# create pub subnet 1
resource "aws_subnet" "pubsub01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pubsub01-cidr
  availability_zone = var.az1
  tags = {
    Name = var.tag-pubsub01
  }
}

# create pub subnet 2
resource "aws_subnet" "pubsub02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pubsub02-cidr
  availability_zone = var.az2
  tags = {
    Name = var.tag-pubsub02
  }
}

# create prv subnet 1
resource "aws_subnet" "prvtsub01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.prvtsub01-cidr
  availability_zone = var.az1
  tags = {
    Name = var.tag-prvtsub01
  }
}

# create prv subnet 2
resource "aws_subnet" "prvtsub02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.prvtsub02-cidr
  availability_zone = var.az2
  tags = {
    Name = var.tag-prvtsub02
  }
}
# create an IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.tag-igw
  }
}
# create a public route table
resource "aws_route_table" "public-subnet-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr-all
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.tag-public-subnet-RT
  }
}
# assiociation of route table to public subnet 1
resource "aws_route_table_association" "Public-RT-ass" {
  subnet_id      = aws_subnet.pubsub01.id
  route_table_id = aws_route_table.public-subnet-RT.id
}

# assiociation of route table to public subnet 2
resource "aws_route_table_association" "Public-RT-ass-2" {
  subnet_id      = aws_subnet.pubsub02.id
  route_table_id = aws_route_table.public-subnet-RT.id
}

# Allocate Elastic IP Address (EIP )
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway" {
  domain = "vpc"

  tags = {
    Name = var.tag-EIP
  }
}

# Create Nat Gateway  in Public Subnet 1
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip-for-nat-gateway.id
  subnet_id     = aws_subnet.pubsub01.id

  tags = {
    Name = var.tag-nat-gateway
  }
}

# Create Private Route Table  and Add Route Through Nat Gateway 
# terraform aws create route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.cidr-all
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = var.tag-private-route-table
  }
}

# Associate Private Subnet 1 with "Private Route Table "
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.prvtsub01.id
  route_table_id = aws_route_table.private-route-table.id
}

# Associate Private Subnet 2 with "Private Route Table "
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.prvtsub02.id
  route_table_id = aws_route_table.private-route-table.id
}


#Security Group for SonarQube Server
resource "aws_security_group" "sonarqube-sg" {
  name        = var.sonarqube-sg
  description = "sonarqube-sg"
  vpc_id      = aws_vpc.vpc.id
  # Inbound Rules
  ingress {
    description = "ssh access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "SonarQube port"
    from_port   = var.port_sonar
    to_port     = var.port_sonar
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  }
  tags = {
    Name = var.sonarqube-sg
  }
}
  
#Creating Jenkins security group
resource "aws_security_group" "Jenkins_SG" {
  name        = var.Jenkins_SG
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "Allow http access"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
   ingress {
    description = "Allow proxy access"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  } 
  tags = {
    Name = var.Jenkins_SG
  }
}
  
# Bastion and ansible security_groups
resource "aws_security_group" "bastion-ansible" {
  name        = var.bastion-ansible-sg
  description = "Bastion and Ansible Security Group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "bastion-ansible ssh port"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  } 
  tags = {
    Name = var.bastion-ansible-sg
  }
}

#Creating Nexus security group
resource "aws_security_group" "Nexus_SG" {
  name        = var.Nexus_SG
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow ssh Access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "Allow nexus access"
    from_port   = var.port_nexus
    to_port     = var.port_nexus
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "Allow nexus access"
    from_port   = var.port_nexus2
    to_port     = var.port_nexus2
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  } 
  tags = {
    Name = var.Nexus_SG
  }
}

#Creating MSQL RDS Database security group
resource "aws_security_group" "MYSQL_RDS_SG" {
  name        = var.RDS_SG
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow MYSQL access"
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr-all]
  }
  tags = {
    Name = var.RDS_SG
  }
}

#Docker security_groups
resource "aws_security_group" "docker-SG" {
  name        = var.docker-SG
  description = "Docker Security Group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "docker ssh port"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "docker port proxy"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "http port"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  ingress {
    description = "https port"
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = "tcp"
    cidr_blocks = [var.cidr-all]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"    
    cidr_blocks = [var.cidr-all]
  }
  tags = {
    Name = var.docker-SG
  }
}
#creating keypair
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

#create local file for private keypair
resource "local_file" "keypair-file" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}

#creating public key resources
resource "aws_key_pair" "key_pair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.keypair.public_key_openssh
}