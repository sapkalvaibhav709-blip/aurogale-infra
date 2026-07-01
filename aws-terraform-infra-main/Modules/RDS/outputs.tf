output "rds_endpoint" {
  value = aws_db_instance.PostgreSQL.endpoint
}

output "rds_port" {
  value = aws_db_instance.PostgreSQL.port
}

output "rds_identifier" {
  value = aws_db_instance.Pos.identifier
}

output "security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.main.name
}