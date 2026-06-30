module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"

  cidr = var.vpc_cidr

  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  subnet_ids = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {

    default = {

      instance_types = ["t3.large"]

      min_size = 2

      max_size = 5

      desired_size = 2

      capacity_type = "ON_DEMAND"

      ami_type = "AL2_x86_64_STANDARD"

      disk_size = 30
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}