####################################
# Security Group
####################################

resource "aws_security_group" "redis" {

  name        = "redis-security-group"
  description = "Redis Security Group"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "redis-sg"
  }
}

####################################
# Subnet Group
####################################

resource "aws_elasticache_subnet_group" "redis" {

  name = "redis-subnet-group"

  subnet_ids = var.private_subnet_ids
}

####################################
# Parameter Group
####################################

resource "aws_elasticache_parameter_group" "redis" {

  family = "redis7"

  name = "redis-parameter-group"
}

####################################
# Redis Replication Group
####################################

resource "aws_elasticache_replication_group" "redis" {

  replication_group_id = "shopping-redis"

  description = "Production Redis Cluster"

  engine = "redis"

  engine_version = var.engine_version

  node_type = var.node_type

  port = 6379

  parameter_group_name = aws_elasticache_parameter_group.redis.name

  subnet_group_name = aws_elasticache_subnet_group.redis.name

  security_group_ids = [
    aws_security_group.redis.id
  ]

  num_node_groups = 1

  replicas_per_node_group = 1

  automatic_failover_enabled = true

  multi_az_enabled = true

  at_rest_encryption_enabled = true

  transit_encryption_enabled = true

  auto_minor_version_upgrade = true

  snapshot_retention_limit = 7

  snapshot_window = "03:00-04:00"

  maintenance_window = "sun:05:00-sun:06:00"

  tags = {
    Environment = "Production"
    Terraform   = "true"
  }
}