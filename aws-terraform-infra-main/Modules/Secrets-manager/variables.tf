variable "aws_region" {
  default = "ap-south-1"
}

variable "aurogale-secret" {
  default = "shopping-app/database"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_host" {}

variable "db_port" {
  default = "5432"
}

variable "aurogale-PostgreSQL" {
  default = "shoppingdb"
}