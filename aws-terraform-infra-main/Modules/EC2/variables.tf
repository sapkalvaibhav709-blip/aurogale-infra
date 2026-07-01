variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_name" {
  default = "API Server"
}

variable "instance_type" {
  default = "m5a.xlarge"
}

variable "key_name" {
  description = "api-server-key"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"
}