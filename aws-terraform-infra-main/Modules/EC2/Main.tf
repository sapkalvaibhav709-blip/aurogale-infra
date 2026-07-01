#####################################
# Latest Amazon Linux 2023 AMI
#####################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

#####################################
# Security Group
#####################################

resource "aws_security_group" "ec2_sg" {

  name = "api-server-ec2-sg"

  description = "EC2 Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "api-server-sg"
  }
}

#####################################
# IAM Role
#####################################

resource "aws_iam_role" "ec2_role" {

  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "profile" {

  name = "EC2SSMProfile"

  role = aws_iam_role.ec2_role.name
}

#####################################
# Application Server
#####################################

resource "aws_instance" "app_server" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = "m5a.xlarge"

  subnet_id = var.private_subnet_id

  key_name = api-server-key

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.profile.name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  root_block_device {

    volume_size = 100

    volume_type = "gp3"

    encrypted = true
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install docker git -y
systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "Application-Server"
    Environment = "Production"
  }
}

#####################################
# Database/Application Server
#####################################

resource "aws_instance" "db_server" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = "r5.large"

  subnet_id = var.private_subnet_id

  key_name = app-server-key

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.profile.name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  root_block_device {

    volume_size = 100

    volume_type = "gp3"

    encrypted = true
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install docker git mysql -y
systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "Database-Server"
    Environment = "Production"
  }
}