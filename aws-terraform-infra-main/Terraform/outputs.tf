output "vpc_id" {

  value = module.vpc.vpc_id
}

output "public_subnets" {

  value = module.vpc.public_subnet_ids
}

output "private_subnets" {

  value = module.vpc.private_subnet_ids
}

output "cluster_name" {

  value = module.eks.cluster_name
}

output "cluster_endpoint" {

  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {

  value = module.rds.rds_endpoint
}

output "redis_endpoint" {

  value = module.redis.primary_endpoint
}

output "repository_url" {

  value = module.ecr.repository_url
}

output "bucket_name" {

  value = module.s3.bucket_name
}