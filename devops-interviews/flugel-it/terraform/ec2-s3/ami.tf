data "aws_ami" "image" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "image-id"
    values = [
       "ami-00a208c7cdba991ea",
    ]
  }
}
