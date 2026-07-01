#######################################
# ECR Repository
#######################################

resource "aws_ecr_repository" "repo" {

  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.repository_name
    Environment = "Production"
    Terraform   = "true"
  }
}

#######################################
# Lifecycle Policy
#######################################

resource "aws_ecr_lifecycle_policy" "policy" {

  repository = aws_ecr_repository.repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Keep only latest 10 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}