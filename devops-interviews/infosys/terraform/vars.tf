variable "ssh_key_pair" { default = "" }
variable "instance_type" { default = "t3a.small" }
variable "management_ip" { default = "0.0.0.0/0"}
variable "region" { default = "sa-east-1"}
variable "image" {
  type = map(string)
  default = {
    # Amazon Linux 2 AMI IDs
    "af-south-1"        = "ami-0cabcda36fd637741" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-east-1"         = "ami-a43370d5"          # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-northeast-1"    = "ami-07b572b14dfaa25c2" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-northeast-2"    = "ami-05cb4a609494ad00a" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-northeast-3"    = "ami-0f1ac8fc2a515b641" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-south-1"        = "ami-0747413f20da0ff83" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-southeast-1"    = "ami-078a9875b19f924b5" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ap-southeast-2"    = "ami-0892dd8d71ba3afd6" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "ca-central-1"      = "ami-0e72ec78c2465045b" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-central-1"      = "ami-07aee05e1814f96f5" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-north-1"        = "ami-0ec637bfa04cea258" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-south-1"        = "ami-0d928824447233c2f" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-west-1"         = "ami-09eb2d6d439ae885e" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-west-2"         = "ami-0ceaab95376d183a9" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "eu-west-3"         = "ami-0a7a3915e8d2d2235" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "me-south-1"        = "ami-0bbdef136bb5862b4" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "sa-east-1"         = "ami-056b66f7e527ffeb6" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "us-east-1"         = "ami-05a91a726af26a821" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "us-east-2"         = "ami-005f397170411956f" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "us-west-1"         = "ami-00ca774e72ecd99b5" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
    "us-west-2"         = "ami-0b73f02086e97035b" # amzn2-ami-minimal-hvm-2.0.20200722.0-x86_64-ebs
  }
}