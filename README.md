![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/umotif-public/terraform-aws-alb?style=social)

# AWS Application and Network Load Balancer Terraform module

Terraform module which creates Application and/or Network Load Balancer resources in AWS.

These types of resources are supported:

* [Load Balancer](https://www.terraform.io/docs/providers/aws/r/lb.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)

## Terraform versions

Terraform 0.12. Pin module version to `~> v2.1`. Submit pull-requests to `master` branch.

## Usage

### Application Load Balancer

```hcl
module "alb" {
  source = "umotif-public/alb/aws"
  version = "~> 2.1.0"

  name_prefix = "complete-alb"

  load_balancer_type = "application"

  internal = false
  vpc_id             = "vpc-abasdasd132"
  subnets            = ["subnet-abasdasd132123", "subnet-abasdasd132123132"]

  access_logs = {
    bucket = "alb-logs"
  }

  tags = {
    Project = "Test"
  }
}
```

### Network Load Balancer

```hcl
module "nlb" {
  source = "umotif-public/alb/aws"
  version = "~> 2.1.0"

  name_prefix = "complete-nlb"

  load_balancer_type = "network"

  vpc_id             = "vpc-abasdasd132"
  subnets            = ["subnet-abasdasd132123", "subnet-abasdasd132123132"]

  access_logs = {
    bucket = "nlb-logs"
  }

  tags = {
    Project = "Test"
  }
}
```

## Examples

* [Application Load Balancer ALB](https://github.com/umotif-public/terraform-aws-alb/tree/master/examples/alb)
* [Application Load Balancer ALB with S3 access logs](https://github.com/umotif-public/terraform-aws-alb/tree/master/examples/alb-with-s3-access-logs)
* [Application Load Balancer NLB](https://github.com/umotif-public/terraform-aws-alb/tree/master/examples/nlb)

## Authors

## Authors

Module managed by [uMotif](https://github.com/umotif-public/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.frontend_http_to_https_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_port_443_ingress_for_http_to_https_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_port_80_ingress_for_http_to_https_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | An Access Logs block. | `map(string)` | `{}` | no |
| <a name="input_cidr_blocks_redirect"></a> [cidr\_blocks\_redirect](#input\_cidr\_blocks\_redirect) | List of CIDR ranges to allow at security group level. Defaults to 0.0.0.0/0 | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the all resources. | `string` | `"Managed by Terraform"` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. | `bool` | `true` | no |
| <a name="input_enable_http_to_https_redirect"></a> [enable\_http\_to\_https\_redirect](#input\_enable\_http\_to\_https\_redirect) | Enable default redirect rule from port 80 to 443. | `bool` | `false` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | (Optional) The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Provision an internal load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| <a name="input_load_balancer_create_timeout"></a> [load\_balancer\_create\_timeout](#input\_load\_balancer\_create\_timeout) | Timeout value when creating the ALB. | `string` | `"15m"` | no |
| <a name="input_load_balancer_delete_timeout"></a> [load\_balancer\_delete\_timeout](#input\_load\_balancer\_delete\_timeout) | Timeout value when deleting the ALB. | `string` | `"15m"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of load balancer to provision (network or application). | `string` | `"application"` | no |
| <a name="input_load_balancer_update_timeout"></a> [load\_balancer\_update\_timeout](#input\_load\_balancer\_update\_timeout) | Timeout value when updating the ALB. | `string` | `"15m"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A prefix used for naming resources. | `string` | n/a | yes |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | A list of subnet mapping blocks describing subnets to attach to network load balancer | `list(map(string))` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnet IDs to attach to the LB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the load balancer. |
| <a name="output_arn_suffix"></a> [arn\_suffix](#output\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_name"></a> [name](#output\_name) | The name of the load balancer. |
| <a name="output_origin_id"></a> [origin\_id](#output\_origin\_id) | First part of the DNS name of the load balancer. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```

