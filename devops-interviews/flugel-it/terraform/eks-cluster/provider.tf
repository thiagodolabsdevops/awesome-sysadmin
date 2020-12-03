# Provider Configuration

provider "aws" {
    version = "~> 2.0"
}

provider "kubernetes" {
    version = "~> 1.10"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
