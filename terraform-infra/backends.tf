terraform {
  backend "s3" {
    bucket = "lgac-terraformstate"
    key    = "state/terraform.tfstate"
    region = "sa-east-1"
  }
}