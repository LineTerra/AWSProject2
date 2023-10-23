# create application load balancer
resource "aws_lb" "application_load_balancer"{
  name               = "projectnm-alb"
  internal           =  false
  load_balancer_type = "application"
  # security_groups_name    = [aws_security_group.allow-ssh.name]

  subnets = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id, aws_subnet.main-public-3.id]
  
  #subnets = aws_subnet.main-public-1[*].id
  
  enable_deletion_protection = false

  tags   = {
    Name = "projectnm-alb"
  }
}



# create target group
resource "aws_lb_target_group" "myalb_target_group" {
  name        = "projectnm-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myalb_target_group.arn
  }
  }


