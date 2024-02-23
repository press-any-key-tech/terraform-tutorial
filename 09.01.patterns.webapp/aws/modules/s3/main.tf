resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_acl" "bucket-acl" {
#   bucket = aws_s3_bucket.bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  # depends_on = [aws_s3_bucket_acl.bucket-acl]
}


# resource "aws_s3_bucket_acl" "bucket-acl" {
#   bucket     = aws_s3_bucket.bucket.id
#   acl        = "public-read"
#   depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
# }

# resource "aws_iam_user" "bucket_user" {
#   name = format("%s-%s-bucket-user", var.environment, var.project)
# }


resource "aws_s3_bucket_website_configuration" "bucket-website" {
  count  = var.enable_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_policy" "access-policy" {
  bucket = aws_s3_bucket.bucket.id
  # TODO: modify this horrible paths
  policy = templatefile(var.enable_website_hosting ? "${path.module}/../../policies/s3-read-policy.json" : "${path.module}/../../policies/s3-read-write-policy.json", { bucket = var.bucket_name })

  # Important! Without this depends we will have an Access Denied error
  depends_on = [aws_s3_bucket_public_access_block.bucket_access]

}

# Upload example index
resource "aws_s3_object" "example-index" {

  count = var.enable_website_hosting ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "${path.module}/../../data/index.html"
  acl    = "public-read"
}

