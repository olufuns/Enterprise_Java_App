output "ansible-ip" {
    value = aws_instance.ansible_server.public_ip
}