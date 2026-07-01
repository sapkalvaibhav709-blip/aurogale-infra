#################################################
# VPC
#################################################

module "vpc" {

  source = "./Modules/VPC"

  aws_region = var.aws_region
}

#################################################
# ECR
#################################################

module "ecr" {

  source = "./Modules/ECR"

  repository_name = "shopping-app"

  depends_on = [
    module.vpc
  ]
}

#################################################
# S3
#################################################

module "s3" {

  source = "./Modules/S3"

  bucket_name = "aurogale-app-prod-storage-123456"

  depends_on = [
    module.vpc
  ]
}

#################################################
# Secrets Manager
#################################################

module "secrets" {

  source = "./Modules/Secrets-manager"

  depends_on = [
    module.vpc
  ]
}

#################################################
# Redis
#################################################

module "redis" {

  source = "./Modules/Redis"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [
    module.vpc
  ]
}

#################################################
# RDS
#################################################

module "rds" {

  source = "./Modules/RDS"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [
    module.redis
  ]
}

#################################################
# EC2
#################################################

module "ec2" {

  source = "./Modules/EC2"

  vpc_id = module.vpc.vpc_id

  public_subnet_id = module.vpc.public_subnet_ids[0]

  depends_on = [
    module.vpc
  ]
}

#################################################
# EKS
#################################################

module "eks" {

  source = "./Modules/EKS"

  cluster_name = "shopping-eks"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnet_ids

  depends_on = [
    module.vpc
  ]
}

#################################################
# ALB Controller
#################################################

module "alb" {

  source = "./Modules/ALB"

  cluster_name = module.eks.cluster_name

  vpc_id = module.vpc.vpc_id

  depends_on = [
    module.eks
  ]
}