output "ec2_public_ip" {
  value = aws_instance.demo_server.public_ip
}