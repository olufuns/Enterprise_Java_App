# Create Launch Template
resource "aws_launch_template" "prod_lt" {
  name_prefix                 = "prod-asg"
  image_id                    = var.ami-redhat-id
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.prod-lt-sg
  key_name                    = var.keypair_name
  user_data                   = base64encode(templatefile("${path.root}/module/asg-prod/docker-script.sh", {
    var1 = var.nexus-ip,
    var2 = var.newrelic-user-licence,
    var3 = var.newrelic-acct-id
  }))
}