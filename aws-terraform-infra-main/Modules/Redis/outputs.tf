output "primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "reader_endpoint" {
  value = aws_elasticache_replication_group.redis.reader_endpoint_address
}

output "port" {
  value = aws_elasticache_replication_group.redis.port
}

output "security_group" {
  value = aws_security_group.redis.id
}