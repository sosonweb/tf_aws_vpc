variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name tag for the VPC."
  default     = "vpc_sos"
}

variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the private subnet 1"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the private subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_name_1" {
  description = "The name tag for the private subnet."
  default     = "PrivateSubnet1"
}

variable "private_subnet_name_2" {
  description = "The name tag for the private subnet."
  default     = "PrivateSubnet2"
}

variable "availability_zone_1" {
  description = "The availability zone for the private subnet."
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "The availability zone for the private subnet."
  default     = "us-east-1b"
}

variable "private_route_table_name" {
  description = "The name tag for the private route table."
  default     = "PrivateRouteTable"
}

variable "public_subnet_cidr_block_1" {
  description = "The CIDR block for the first public subnet."
  default     = "10.0.2.0/24"
}

variable "public_subnet_cidr_block_2" {
  description = "The CIDR block for the second public subnet."
  default     = "10.0.3.0/24"
}

variable "public_subnet_name_1" {
  description = "The name tag for the first public subnet."
  default     = "PublicSubnet1"
}

variable "public_subnet_name_2" {
  description = "The name tag for the second public subnet."
  default     = "PublicSubnet2"
}

variable "internet_gateway_name" {
  description = "The name tag for the internet gateway."
  default     = "my-igw"
}