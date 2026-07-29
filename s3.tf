########################################
# Frontend S3 Bucket
########################################

resource "aws_s3_bucket" "frontend" {

  bucket = "${var.project_name}-frontend-bucket"

  tags = {
    Name = "Frontend-Bucket"
  }
}

########################################
# Versioning
########################################

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {

    status = "Enabled"
  }
}

########################################
# Server Side Encryption
########################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.frontend.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}
