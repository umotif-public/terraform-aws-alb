provider "aws" {
  region = "eu-west-1"
}

#####
# VPC and subnets
#####
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
#####
# Application Load Balancer
#####
module "alb" {
  source = "../../"

  name_prefix = "alb-example-access-logs"

  load_balancer_type = "application"

  internal = false
  vpc_id   = data.aws_vpc.default.id
  subnets  = data.aws_subnet_ids.all.ids

  enable_http_to_https_redirect = true
  cidr_blocks_redirect          = ["10.10.0.0/16"]

  access_logs = {
    bucket  = aws_s3_bucket.alb_access_logs.bucket
    prefix  = "example-with-access-logs-alb"
    enabled = true
  }

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

#####
# S3 bucket storing ALB access logs
#####
locals {
  alb_root_account_id = "156460612806" # valid account id for Ireland Region. Full list -> https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = "example-alb-access-logs-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowELBRootAccount",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.alb_root_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::example-alb-access-logs-bucket/*"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::example-alb-access-logs-bucket/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::example-alb-access-logs-bucket"
    }
  ]
}
POLICY

  tags = {
    Environment = "test"
  }
}
