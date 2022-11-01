resource "aws_lb" "main" {
  name = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  subnets            = var.subnets
  security_groups    = aws_security_group.main.*.id

  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id     = subnet_mapping.value.subnet_id
      allocation_id = lookup(subnet_mapping.value, "allocation_id", null)
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.name_prefix
    },
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb_listener" "frontend_http_to_https_redirect" {
  count = var.enable_http_to_https_redirect ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
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

  tags = var.tags
}

resource "aws_security_group" "main" {
  count       = var.load_balancer_type == "network" ? 0 : 1
  name_prefix = "${var.name_prefix}-sg-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_port_80_ingress_for_http_to_https_redirect" {
  count       = var.load_balancer_type == "application" && var.enable_http_to_https_redirect && var.enable_ingress_security_group_rules ? 1 : 0
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks_redirect

  security_group_id = aws_security_group.main[0].id
}

resource "aws_security_group_rule" "allow_port_443_ingress_for_http_to_https_redirect" {
  count       = var.load_balancer_type == "application" && var.enable_http_to_https_redirect && var.enable_ingress_security_group_rules ? 1 : 0
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks_redirect

  security_group_id = aws_security_group.main[0].id
}

resource "aws_security_group_rule" "egress" {
  count             = var.load_balancer_type == "network" ? 0 : 1
  security_group_id = aws_security_group.main[0].id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
