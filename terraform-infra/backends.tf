terraform {
  backend "s3" {
    bucket = "your-bucket"
    key    = "state/terraform.tfstate"
    region = "your-region"
  }
}