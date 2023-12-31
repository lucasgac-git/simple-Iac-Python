module "networking" {
  source          = "./networking"
  access_ip       = var.access_ip
  cidr            = local.vpc_cidr
  security_groups = local.security_groups
  public_cidr     = "10.24.1.0/24"
  private_cidr    = "10.24.2.0/24"
  az              = local.az
}

module "webserver" {
  source          = "./ec2"
  public_sg       = module.networking.public_sg
  public_subnet   = module.networking.public_subnet
  instance_type   = "t2.micro"
  volume_size     = 10
  key_name        = "mykey"
  public_key_path = "/path/to/mykey.pub"

}

module "dbserver" {
  source          = "./ec2-private"
  private_sg      = module.networking.mysql_sg
  private_subnet  = module.networking.private_subnet
  instance_type   = "t2.micro"
  volume_size     = 10
  instance_state  = "running"
  key_name        = "mykey2"
  public_key_path = "/path/to/mykey2.pub"
}