variable "aws_region" {
  default = "ap-south-1"
}

variable "aurogale-db" {
  default = "shoppingdb"
}

variable "admin" {
  default = "admin"
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  default = "db.r5.large"
}

variable "allocated_storage" {
  default = 200
}

variable "engine_version" {
  default = "8.0.39"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type = list(string)
}