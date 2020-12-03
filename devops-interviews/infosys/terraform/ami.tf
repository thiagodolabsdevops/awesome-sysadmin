data "aws_ami" "image" {
  most_recent = true
  owners      = ["amazon"]
  name        = var.image[var.region]
}
