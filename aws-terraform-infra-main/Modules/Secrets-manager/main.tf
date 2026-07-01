#########################################
# AWS Secrets Manager Secret
#########################################

resource "aws_secretsmanager_secret" "database" {

  name                    = var.secret_name

  description             = "Database credentials"

  recovery_window_in_days = 7

  tags = {
    Name        = var.secret_name
    Environment = "Production"
    Terraform   = "true"
  }
}

#########################################
# Secret Value
#########################################

resource "aws_secretsmanager_secret_version" "database" {

  secret_id = aws_secretsmanager_secret.database.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.db_host
    port     = var.db_port
    database = var.database_name
  })
}