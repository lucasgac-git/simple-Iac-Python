#################
# VPC declaration
#################


resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "Demo-vpc"
  }
}

#########
# Subnets
#########

resource "aws_subnet" "demo_public_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = var.public_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az

  tags = {
    Name = "Demo-public-subnet"
  }
}

resource "aws_subnet" "demo_private_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = var.private_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.az

  tags = {
    Name = "Demo-private-subnet"
  }
}

##################
# Internet Gateway
##################

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "Demo-igw"
  }
}

############
# Elastic IP
############

resource "aws_eip" "db_eip" {
  depends_on = [aws_internet_gateway.demo_igw]

  tags = {
    Name = "Database-eip"
  }

}

#############
# NAT Gateway
#############

resource "aws_nat_gateway" "db_natgw" {
  allocation_id = aws_eip.db_eip.id
  subnet_id     = aws_subnet.demo_public_subnet.id

  tags = {
    Name = "Database-Nat-gw"
  }

}



##############
# Route tables
##############

resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = {
    Name = "Demo-public-rt"
  }
}

resource "aws_route_table" "demo_private_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.db_natgw.id
  }

  tags = {
    Name = "Demo-private-rt"
  }
}

#########################
# Route table Association
#########################

resource "aws_route_table_association" "demo_public_assoc" {
  subnet_id      = aws_subnet.demo_public_subnet.id
  route_table_id = aws_route_table.demo_public_rt.id
}

resource "aws_route_table_association" "demo_pritave_assoc" {
  subnet_id      = aws_subnet.demo_private_subnet.id
  route_table_id = aws_route_table.demo_private_rt.id
}

############################
# Security Groups
# declared in root/locals.tf
############################

resource "aws_security_group" "demo_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.demo_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}