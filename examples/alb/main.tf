#####
# VPC and subnets
#####
data "aws_vpc" "default" {
  default = true
}

#####
# VPC and subnets
#####

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
#####
# Application Load Balancer
#####
module "alb" {
  source = "../../"

  name_prefix = "complete-alb-example"

  load_balancer_type = "application"

  internal = false
  vpc_id   = data.aws_vpc.default.id
  subnets  = data.aws_subnets.all.ids

  enable_http_to_https_redirect = true
  cidr_blocks_redirect          = ["10.10.0.0/16"]

  tags = {
    Project = "Test"
  }
}

#####
# ALB listener
#####
resource "aws_lb_listener" "alb_80_redirect_to_443" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#####
# SGs
#####
resource "aws_security_group_rule" "alb_ingress_443" {
  security_group_id = module.alb.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
