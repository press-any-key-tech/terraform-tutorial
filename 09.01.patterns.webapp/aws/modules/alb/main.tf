# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = format("%s-lb-sg", var.lb_name)
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.listener_port
    to_port     = var.listener_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-lb-sg", var.lb_name)
  }
}


resource "aws_lb" "main" {
  name            = var.lb_name
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.lb.id]
  tags = {
    Name = var.lb_name
  }
}

# TODO: Allow multiple listeners (multiple ports and protocols)
# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  # TODO: If certificate is provided, use it
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Error: No target group defined"
      status_code  = "503"
    }
  }

}


