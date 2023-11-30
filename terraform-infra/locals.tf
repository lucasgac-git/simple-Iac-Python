locals {
  vpc_cidr    = "10.24.0.0/16"
  public_cidr = "10.24.1.0/24"
}

locals {
  az = "sa-east-1a"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security group for Public Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }

        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    db = {
      name        = "mysql_sg"
      description = "Security Group for Database Access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.public_cidr]
        }
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [local.public_cidr]
        }
        icmp = {
          from        = 0
          to          = 0
          protocol    = "icmp"
          cidr_blocks = [local.public_cidr]
        }
      }

    }
  }
}