resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  force_destroy = true   # Deletes bucket even if not empty (⚠️ Be careful)
}

# To enable versioning and block public access
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
