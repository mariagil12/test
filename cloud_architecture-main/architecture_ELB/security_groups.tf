###################################################
# Security groups
###################################################

resource "aws_security_group" "sg_for_elb" {
  name   = "sg_for_elb"
  vpc_id = aws_vpc.main.id

  # allow only http(80) and https(443)
  dynamic "ingress" {
    for_each = var.sg_ports_for_internet
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      description      = "Allow all request from anywhere"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sg_for_ec2" {
  name   = "sg_for_ec2"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow http request from Load Balancer"
    protocol        = "tcp"
    from_port       = 3000 # range of
    to_port         = 3000 # port numbers
    security_groups = [aws_security_group.sg_for_elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# resource "aws_security_group" "sg_for_private_endpoint" {
#   name   = "sg_for_private_endpoint"
#   vpc_id = aws_vpc.main.id
#
#   ingress {
#     description     = "Allow http request"
#     protocol        = "tcp"
#     from_port       = 80 # range of
#     to_port         = 80 # port numbers
#     protocol         = "tcp"
#     description      = "Allow all request from anywhere"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
#
#
#   ingress {
#     description     = "Allow https request"
#     protocol        = "tcp"
#     from_port       = 443 # range of
#     to_port         = 443 # port numbers
#     protocol         = "tcp"
#     description      = "Allow all request from anywhere"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }