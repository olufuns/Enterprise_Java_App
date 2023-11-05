output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "pubsub01-id" {
  value = aws_subnet.pubsub01.id
}
output "pubsub02-id" {
  value = aws_subnet.pubsub02.id
}
output "prvtsub01" {
  value = aws_subnet.prvtsub01.id
}
output "prvtsub02" {
  value = aws_subnet.prvtsub02.id
}
output "igw" {
  value = aws_internet_gateway.igw.id
}
output "public-rt" {
  value = aws_route_table.public-subnet-RT.id
}
output "EIP" {
  value = aws_eip.eip-for-nat-gateway.id
}
output "natgateway" {
  value = aws_nat_gateway.nat-gateway.id
}
output "route_table" {
  value = aws_route_table.private-route-table.id
}
output "route_table_association" {
  value = aws_route_table_association.private-subnet-1-route-table-association.id
}
output "sonarqube-sg" {
  value = aws_security_group.sonarqube-sg.id
}
output "bastion-ansible-sg" {
  value = aws_security_group.bastion-ansible.id
}
output "docker-sg" {
  value = aws_security_group.docker-SG.id
}
output "nexus-sg" {
  value = aws_security_group.Nexus_SG.id
}
output "jenkins-sg" {
  value = aws_security_group.Jenkins_SG.id
}
output "mysql-sg" {
  value = aws_security_group.MYSQL_RDS_SG.id
}
output "Jenkins_SG" {
  value = aws_security_group.Jenkins_SG
}
output "Nexus_SG" {
  value = aws_security_group.Nexus_SG
}
output "MYSQL_RDS_SG" {
  value = aws_security_group.MYSQL_RDS_SG
}
output "keypairid" {
  value = aws_key_pair.key_pair.id
}
output "privatekeypair" {
  value = tls_private_key.keypair.private_key_pem
}