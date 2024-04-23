provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}
