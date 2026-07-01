variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"
}