resource "aws_s3_bucket" "website-prod" {
  bucket = "website-prod"
  acl    = "public-read"

  tags = {
    Name        = "website-prod"
    Environment = "Prod"
    InUse = "Yes"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  provisioner "local-exec" {
    command = "aws s3 cp --acl public-read ./files/ s3://${aws_s3_bucket.website-prod.id} --recursive"
  }
}

output "website_url" {
  value = "http://${aws_s3_bucket.flugel-website.bucket}.s3-website-${var.region}.amazonaws.com"
}

resource "aws_s3_bucket" "website-test" {
  bucket = "website-test"
  acl    = "private"

  tags = {
    Name        = "website-test"
    Environment = "Test"
    InUse = "No"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  provisioner "local-exec" {
    command = "aws s3 cp --acl public-read ./files/ s3://${aws_s3_bucket.website-test.id} --recursive"
  }
}
