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
  cidr_block              = var.private_subnet_cidr_block_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_name_1
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_name_2
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.public_subnet_cidr_block_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = var.public_subnet_name_1
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.public_subnet_cidr_block_2
  availability_zone = var.availability_zone_2

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

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}
resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_2.id
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc_1.id
}
