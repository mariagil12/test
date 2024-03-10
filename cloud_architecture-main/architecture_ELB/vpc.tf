###################################################
# VPC
###################################################
resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "vpc-tfp"
  }
}

###################################################
# Subnets
###################################################
resource "aws_subnet" "subnet_1a_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.1.0/24"
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "eu-west-1a"
  tags = {
      Name = "Public subnet 1a"
  }
}

resource "aws_subnet" "subnet_1b_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.2.0/24"
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "eu-west-1b"
  tags = {
      Name = "Public subnet 1b"
  }
}

resource "aws_subnet" "subnet_2a_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.5.0/24"
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "eu-west-1a"
  tags = {
      Name = "Private subnet 2a"
  }
}

resource "aws_subnet" "subnet_2b_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.6.0/24"
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "eu-west-1b"
  tags = {
      Name = "Private subnet 2b"
  }
}

###################################################
# Internet Gateway
###################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "IG for public subnets"
  }
}

###################################################
# Elastic IP for NAT gateway
###################################################
resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.gw]
  vpc        = true
  tags = {
    Name = "EIP_for_NAT"
  }
}

###################################################
# NAT gateway
###################################################
# (for the private subnet to access internet - eg. ec2 instances downloading softwares from internet)
resource "aws_nat_gateway" "nat_for_private_subnet" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet_1a_public.id # nat should be in public subnet

  tags = {
    Name = "NAT for private subnet"
  }

  depends_on = [aws_internet_gateway.gw]
}











