# ASG with Launch template
resource "aws_launch_template" "ec2_launch_templ" {
  name_prefix   = "ec2_launch_templ"
  image_id      = "ami-0ef9e689241f0bb6e" # To note: AMI is specific for each region
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   =  aws_subnet.subnet_2a_private.id
    security_groups             = [aws_security_group.sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "instance" # Name for the EC2 instances
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  vpc_zone_identifier = [ # Creating EC2 instances in private subnet
    aws_subnet.subnet_2a_private.id, aws_subnet.subnet_2b_private.id
  ]

  launch_template {
    id      = aws_launch_template.ec2_launch_templ.id
    version = "$Latest"
  }
}
