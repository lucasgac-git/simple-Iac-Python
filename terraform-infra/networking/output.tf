output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "public_sg" {
  value = aws_security_group.demo_sg["public"].id
}

output "mysql_sg" {
  value = aws_security_group.demo_sg["db"].id
}

output "public_subnet" {
  value = aws_subnet.demo_public_subnet.id
}

output "private_subnet" {
  value = aws_subnet.demo_private_subnet.id
}