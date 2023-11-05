output "Jenkins_Server" {
  value = aws_instance.Jenkins_Server.id
}
output "Jenkins-ip" {
  value = aws_instance.Jenkins_Server.private_ip
}
output "Jenkins-dns" {
  value = aws_elb.lb.dns_name
}