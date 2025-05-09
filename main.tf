resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket" "dest" {
  bucket = var.dest_bucket_name
  }

# Public access block separately, no longer needed as part of individual bucket
# block configurations but still a good practice to use.

resource "aws_s3_bucket_public_access_block" "source_block" {
  bucket = aws_s3_bucket.source.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "dest_block" {
  bucket = aws_s3_bucket.dest.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
