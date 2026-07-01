##############################################
# S3 Bucket
##############################################

resource "aws_s3_bucket" "bucket" {

  bucket = var.bucket_name

  force_destroy = false

  tags = {
    Name        = var.bucket_name
    Environment = "Production"
    Terraform   = "true"
  }
}

##############################################
# Versioning
##############################################

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

##############################################
# Server Side Encryption
##############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}

##############################################
# Public Access Block
##############################################

resource "aws_s3_bucket_public_access_block" "public" {

  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true

  block_public_policy     = true

  ignore_public_acls      = true

  restrict_public_buckets = true
}

##############################################
# Ownership Controls
##############################################

resource "aws_s3_bucket_ownership_controls" "ownership" {

  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

##############################################
# Lifecycle Rule
##############################################

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {

  bucket = aws_s3_bucket.bucket.id

  rule {

    id = "cleanup-old-versions"

    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}