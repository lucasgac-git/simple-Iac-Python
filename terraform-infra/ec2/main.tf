data "aws_ami" "server" {
  most_recent = true
  # Informação sobre a imagem
  # aws ec2 describe-images --image-ids ami-0af6e9042ea5a4e3e --region sa-east-1
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "demo_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "demo_server" {
  instance_type          = var.instance_type #t2.micro
  ami                    = data.aws_ami.server.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet
  key_name               = aws_key_pair.demo_key.id
  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "Demo-web-server"
  }
}