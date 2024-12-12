resource "random_string" "db_username" {
  length  = 8
  upper   = false
  lower   = true
  special = false
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>?:;|~"
}


locals {
  db_username = "user_${random_string.db_username.result}"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                     = "mysql-rds-db-credentials"
  description              = "RDS database credentials"
  recovery_window_in_days  = 0
  tags = {
    Name = "RDS DB Credentials"
  }
}


resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = local.db_username
    password = random_password.db_password.result
  })
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "this" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).username
  password               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).password
  multi_az               = true
  publicly_accessible    = false
  vpc_security_group_ids = [var.app_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = true

  tags = {
    Name = "App RDS"
  }
}