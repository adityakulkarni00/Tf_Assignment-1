terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

provider "aws" {
  
}
#Network
resource "aws_vpc" "tf_vpc2" {         # resource type Resource lable
    cidr_block = "10.20.0.0/16"
    tags = {
      "Name" = "tf-vpc"               # name of vpc
      "Description" = "this vpc has subnet 1"
    }
  
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.tf_vpc2.id              # use  type and lable
  cidr_block = "10.20.1.0/24"

  availability_zone = "us-east-1a"
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf_vpc2.id
  tags = {
    "Name" = "tf_internet gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tf_vpc2.id
  tags = {
    Name = "public_route_table"
  }
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.tf_vpc2.id              
  cidr_block = "10.20.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "private-subnet"
  }
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
} 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.private_subnet.id
  tags = {
    Name = "NAT-gateway"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.tf_vpc2.id
  tags = {
    Name = "private_route_table"
  }
}
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}
