terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.28.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}