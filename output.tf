output "sonarqube-ip" {
  value = module.sonarqube.Sonerqube-ip
}
output "ansible-ip" {
  value = module.ansible.ansible-ip
}

output "jenkins-dns" {
  value = module.jenkins.Jenkins-dns
}

output "jenkins-ip" {
  value = module.jenkins.Jenkins-ip
}

output "nexus-ip" {
  value = module.nexus.nexus_ip
}

output "bastion-ip" {
  value = module.bastion.bastion-ip
}
