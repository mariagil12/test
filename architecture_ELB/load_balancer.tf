resource "aws_lb" "lb" {
  name               = "lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_elb.id]
  subnets            = [aws_subnet.subnet_1a_public.id, aws_subnet.subnet_1b_public.id]
  depends_on         = [aws_internet_gateway.gw]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "tf-lb-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}


#Client ---(HTTP:80) ---> ALB ---> TG --- (HTTP:3000) ---> Instance with docker on port
#Since the docker application is exposed on the port 3000 on the instance, 3000
#the instance SG must allow inbound traffic on that port.
#Since the docker works at port 3000, TG port needed to be change to port 3000.
