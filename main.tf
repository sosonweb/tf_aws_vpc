provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24" // Change this CIDR block accordingly
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet2" // Change the name accordingly
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_block_1
  availability_zone = var.availability_zone

  tags = {
    Name = var.public_subnet_name_1
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_block_2
  availability_zone = var.availability_zone
  
  tags = {
    Name = var.public_subnet_name_2
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