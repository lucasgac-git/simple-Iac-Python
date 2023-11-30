terraform {
  backend "s3" {
    bucket = "your s3 bucket"
    key    = "state/terraform.tfstate"
    region = "your region"
  }
}