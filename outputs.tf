output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
}

output "vpc_id" {
  value = aws_vpc.vpc_1.id
  description = "The ID of the VPC created"
}