locals {
  name = "peniel"
}
 provider "vault" {
   token   = ""
   address = "https://olufunsoojo.com"
 }

module "vpc" {
  source                  = "./module/vpc"
  vpc-cidr                = "10.0.0.0/16"
  tag-vpc                 = "${local.name}-vpc"
  pubsub01-cidr           = "10.0.1.0/24"
  az1                     = "eu-west-3a"
  tag-pubsub01            = "${local.name}-pubsub01"
  pubsub02-cidr           = "10.0.2.0/24"
  az2                     = "eu-west-3b"
  tag-pubsub02            = "${local.name}-pubsub02"
  prvtsub01-cidr          = "10.0.3.0/24"
  tag-prvtsub01           = "${local.name}-prvtsub01"
  prvtsub02-cidr          = "10.0.4.0/24"
  tag-prvtsub02           = "${local.name}-prvtsub02"
  tag-igw                 = "${local.name}-igw"
  cidr-all                = "0.0.0.0/0"
  tag-public-subnet-RT    = "${local.name}-pubsubrt"
  tag-EIP                 = "${local.name}-eip"
  tag-nat-gateway         = "${local.name}-natgateway"
  tag-private-route-table = "${local.name}-prvrt"
  port_ssh                = "22"
  port_sonar              = "9000"
  sonarqube-sg            = "${local.name}-sonarqube-sg"
  port_http               = "80"
  Jenkins_SG              = "${local.name}-jenkins-sg"
  bastion-ansible-sg      = "${local.name}-bastion-ansible-sg"
  Nexus_SG                = "${local.name}-nexus-sg"
  port_nexus              = "8081"
  port_nexus2             = "8085"
  RDS_SG                  = "${local.name}-mysql-sg"
  mysql_port              = "3306"
  port_proxy              = "8080"
  port_https              = "443"
  docker-SG               = "${local.name}-docker-sg"
  keypair_name            = "${local.name}-keypair"
}

module "jenkins" {
  source                = "./module/jenkins"
  ami                   = "ami-0d767e966f3458eb5"
  instance_type         = "t2.medium"
  prt_subnet            = module.vpc.prvtsub01
  security_group        = [module.vpc.Jenkins_SG.id]
  key_name              = module.vpc.keypairid
  tag-jenkins-server    = "${local.name}-jenkins-server"
  jenkins-elb           = "${local.name}-jenkins-elb"
  subnet-id             = [module.vpc.pubsub01-id]
  nexus-ip              = module.nexus.nexus_ip
  newrelic-user-licence = "eu01xx91603855fb7b72ce392e1e4389FFFFNRAL"
  newrelic-acct-id      = "4102579"
}

module "asg-stage" {
  source              = "./module/asg-stage"
  ami-redhat-id       = "ami-0d767e966f3458eb5"
  instance_type       = "t2.medium"
  stage-lt-sg         = [module.vpc.docker-sg]
  keypair_name        = module.vpc.keypairid
  vpc-zone-identifier = [module.vpc.prvtsub01, module.vpc.prvtsub02]
  tg-arn              = [module.stage-lb.stage-target-arn]
  stage-asg-name        = "stage-asg"
  asg-policy            = "asg-policy"
  nexus-ip              = module.nexus.nexus_ip
  newrelic-user-licence = "eu01xx91603855fb7b72ce392e1e4389FFFFNRAL"
  newrelic-acct-id      = "4102579"
}

module "asg-prod" {
  source              = "./module/asg-prod"
  ami-redhat-id       = "ami-0d767e966f3458eb5"
  instance_type       = "t2.medium"
  prod-lt-sg          = [module.vpc.docker-sg]
  keypair_name        = module.vpc.keypairid
  vpc-zone-identifier = [module.vpc.prvtsub01, module.vpc.prvtsub02]
  tg-arn                = [module.prod-lb.prod-target-arn]
  prod-asg-name         = "prod-asg"
  asg-policy            = "asg-policy"
  nexus-ip              = module.nexus.nexus_ip
  newrelic-user-licence = "eu01xx91603855fb7b72ce392e1e4389FFFFNRAL"
  newrelic-acct-id      = "4102579"
}

module "sonarqube" {
  source           = "./module/sonarqube"
  ami_ubuntu       = "ami-00983e8a26e4c9bd9"
  instance_type    = "t2.medium"
  key_name         = module.vpc.keypairid
  sonarqube-sg     = module.vpc.sonarqube-sg
  subnet_id        = module.vpc.pubsub02-id
  sonarQube_server = "${local.name}-sonarqube"
}

module "ansible" {
  source             = "./module/ansible"
  ami_redhat         = "ami-0d767e966f3458eb5"
  instance_type      = "t2.medium"
  subnet_id          = module.vpc.pubsub02-id
  bastion-ansible-sg = module.vpc.bastion-ansible-sg
  key_name           = module.vpc.keypairid
  tag-ansible        = "${local.name}-ansible"
  stage-playbook     = "${path.root}/module/ansible/stage-playbook.yml"
  prod-playbook      = "${path.root}/module/ansible/prod-playbook.yml"
  stage-bash-script  = "${path.root}/module/ansible/stage-bash-script.sh"
  prod-bash-script   = "${path.root}/module/ansible/prod-bash-script.sh"
  private-key        = module.vpc.privatekeypair
  nexus-ip           = module.nexus.nexus_ip
}

module "bastion" {
  source               = "./module/bastion"
  ami_redhat           = "ami-0d767e966f3458eb5"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.pubsub02-id
  bastion-ansible-sg   = module.vpc.bastion-ansible-sg
  key_name             = module.vpc.keypairid
  tag-bastion          = "${local.name}-bastion"
  private_keypair_path = module.vpc.privatekeypair
}

module "nexus" {
  source           = "./module/nexus_server"
  redhat_ami       = "ami-0d767e966f3458eb5"
  instance_type_t2 = "t2.medium"
  nexus_sg         = [module.vpc.nexus-sg]
  subnet_id        = module.vpc.pubsub01-id
  key_name         = module.vpc.keypairid
  nexus_name       = "${local.name}-nexus"
  api_key          = ""
  account_id       = ""
}

 data "vault_generic_secret" "mydb_secret" {
  path = "secret/database"
}


module "database" {
  source               = "./module/database"
  db_name              = "acaadpetdb"
  engine               = "mysql"
  db-sg-name           = "${local.name}-db-sng"
  instance_type        = "db.t3.micro"
  vpc_id               = module.vpc.vpc-id
  dbusername           = data.vault_generic_secret.mydb_secret.data["username"]
  dbpassword           = data.vault_generic_secret.mydb_secret.data["password"]
  parameter-group-name = "default.mysql8.0"
  vpc_sg_ids           = module.vpc.mysql-sg
  tag-prvsn1           = module.vpc.prvtsub01
  tag-prvsn2           = module.vpc.prvtsub02
}

module "stage-lb" {
  source          = "./module/stage-lb"
  stage_tg_name   = "${local.name}-stage-tg"
  port_proxy      = "8080"
  vpc_id          = module.vpc.vpc-id
  stage_alb_name  = "${local.name}-stage-alb"
  security_group  = [module.vpc.docker-sg]
  subnet_id       = [module.vpc.pubsub01-id, module.vpc.pubsub02-id]
  tag-stage-alb   = "${local.name}-stage-alb"
  http_port       = "80"
  https_port      = "443"
  certificate_arn = module.acm.acm_certificate
}


module "prod-lb" {
  source              = "./module/prod-lb"
  prod_tg_name        = "${local.name}-prod-tg"
  port_proxy          = "8080"
  vpc_id              = module.vpc.vpc-id
  prod_alb_name       = "${local.name}-prod-alb"
  prod_security_group = [module.vpc.docker-sg]
  prod_subnet_id      = [module.vpc.pubsub01-id, module.vpc.pubsub02-id]
  tag-prod-alb        = "${local.name}-prod-alb"
  http_port           = "80"
  https_port          = "443"
  certificate_arn     = module.acm.acm_certificate
}

module "route53" {
  source            = "./module/route53"
  domain-name       = "olufunsoojo.com"
  domain-name1      = "stage.olufunsoojo.com"
  stage_lb_dns_name = module.stage-lb.stage-alb-dns
  stage_lb_zoneid   = module.stage-lb.stage-alb-zone-id
  domain-name2      = "prod.greatminds.sbs"
  prod_lb_dns_name  = module.prod-lb.prod-alb-dns
  prod_lb_zoneid    = module.prod-lb.prod-alb-zone-id
}

module "acm" {
  source       = "./module/acm"
  domain_name  = "olufunsoojo.com"
  domain_name2 = "*.olufunsoojo.com"
}