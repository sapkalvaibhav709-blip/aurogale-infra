variable "aws_region" {
  default = "ap-south-1"
}

variable "aurogale-redis" {
  default = "aurogale-redis"
}

variable "node_type" {
  default = "cache.t4g.medium"
}

variable "engine_version" {
  default = "7.1"
}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}