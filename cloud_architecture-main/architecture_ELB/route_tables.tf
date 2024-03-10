###################################################
# Route tables
###################################################

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
      Name = "RT public"
  }
}

# route table for private subnet - connecting to NAT
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_for_private_subnet.id
  }
  tags = {
      Name = "RT private"
  }
}

###################################################
# Associations
###################################################

# associate the route table with public subnet 1a
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet_1a_public.id
  route_table_id = aws_route_table.rt_public.id
}

# associate the route table with public subnet 1b
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet_1b_public.id
  route_table_id = aws_route_table.rt_public.id
}

# associate the route table with private subnet 2a
resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.subnet_2a_private.id
  route_table_id = aws_route_table.rt_private.id
}

# associate the route table with private subnet 2b
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.subnet_2b_private.id
  route_table_id = aws_route_table.rt_private.id
}

