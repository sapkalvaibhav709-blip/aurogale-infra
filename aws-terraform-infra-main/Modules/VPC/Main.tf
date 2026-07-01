############################
# VPC
############################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

############################
# Internet Gateway
############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}

############################
# Public Subnet 1
############################

resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet1

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

############################
# Public Subnet 2
############################

resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet2

  availability_zone = "${var.aws_region}b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

############################
# Private Subnet 1
############################

resource "aws_subnet" "private1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet1

  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "private-subnet-1"
  }
}

############################
# Private Subnet 2
############################

resource "aws_subnet" "private2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet2

  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "private-subnet-2"
  }
}

############################
# Elastic IP
############################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

############################
# NAT Gateway
############################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public1.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "nat-gateway"
  }
}

############################
# Public Route Table
############################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

############################
# Private Route Table
############################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

############################
# Public Route Association
############################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id
}

############################
# Private Route Association
############################

resource "aws_route_table_association" "private1" {

  subnet_id = aws_subnet.private1.id

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {

  subnet_id = aws_subnet.private2.id

  route_table_id = aws_route_table.private.id
}