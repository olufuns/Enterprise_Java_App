#Create Nexus Server using a t2.medium redhat ami 
resource "aws_instance" "nexus-server" {
    ami                             = var.redhat_ami
    instance_type                   = var.instance_type_t2
    vpc_security_group_ids          = var.nexus_sg
    subnet_id                       = var.subnet_id
    key_name                        = var.key_name
    associate_public_ip_address      = true
    user_data                       = local.nexus_userdata

    tags = {
        Name  = var.nexus_name
    }
}