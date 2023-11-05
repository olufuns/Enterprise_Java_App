#Create Relational database
 resource "aws_db_instance" "acaadppetdb" {
   allocated_storage      = 10
   db_name                = var.db_name
   engine                 = var.engine
   engine_version         = "8.0"
   instance_class         = var.instance_type
   username               = var.dbusername
   password               = var.dbpassword
   multi_az               = true
   db_subnet_group_name   = aws_db_subnet_group.acaadppet_db_sng.id
   parameter_group_name   = var.parameter-group-name
   vpc_security_group_ids = [var.vpc_sg_ids]
   skip_final_snapshot    = true
 }

 #Create DB Subnet Groups
resource "aws_db_subnet_group" "acaadppet_db_sng" {
  name        = var.db-sg-name
  subnet_ids  = [var.tag-prvsn1, var.tag-prvsn2]

  tags = {
    Name = var.db-sg-name
  }
}