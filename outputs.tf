output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
}

output "vpc_id" {
  value = aws_vpc.this.id
  description = "The ID of the VPC created"
}