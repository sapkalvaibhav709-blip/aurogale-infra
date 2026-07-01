#########################################
# Security Group
#########################################

resource "aws_security_group" "rds_sg" {
  name        = "aurogale-security-group"
  description = "Security Group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "rds-sg"
  }
}

#########################################
# DB Subnet Group
#########################################

resource "aws_db_subnet_group" "main" {

  name = "aurogale-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "shopping-db-subnet-group"
  }
}

#########################################
# Parameter Group
#########################################

resource "aws_db_parameter_group" "mysql" {

  family = "PostgreSQL"

  name = "shopping-mysql-parameter-group"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

#########################################
# RDS Instance
#########################################

resource "aws_db_instance" "mysql" {

  identifier = "aurogale-PostgreSQL"

  engine = "PostgreSQL"

  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  storage_type = "gp3"

  storage_encrypted = true

  db_name = var.db_name

  username = var.db_username

  password = var.db_password

  port = 3306

  multi_az = true

  publicly_accessible = false

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  backup_retention_period = 7

  backup_window = "03:00-04:00"

  maintenance_window = "Sun:05:00-Sun:06:00"

  deletion_protection = true

  skip_final_snapshot = false

  final_snapshot_identifier = "shopping-final-snapshot"

  performance_insights_enabled = true

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  parameter_group_name = aws_db_parameter_group.mysql.name

  auto_minor_version_upgrade = true

  apply_immediately = true

  tags = {
    Environment = "Production"
    Terraform   = "true"
  }
}