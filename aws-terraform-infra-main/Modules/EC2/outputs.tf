output "application_server_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "application_server_private_ip" {
  value = aws_instance.app_server.private_ip
}

output "database_server_public_ip" {
  value = aws_instance.db_server.public_ip
}

output "database_server_private_ip" {
  value = aws_instance.db_server.private_ip
}