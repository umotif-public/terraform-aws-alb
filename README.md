# AWS Application and Network Load Balancer Terraform module

Terraform module which creates Application and/or Network Load Balancer resources in AWS.

These types of resources are supported:

* [Load Balancer](https://www.terraform.io/docs/providers/aws/r/lb.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)

## Terraform versions

Terraform 0.12. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

## Usage

### Application Load Balancer

```hcl
module "alb" {
  source = "umotif-public/alb/aws"
  version = "~> 1.0"
  
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
  version = "~> 1.0"

  name = "complete-nlb"

  load_balancer_type = "network"

  vpc_id             = "vpc-abasdasd132"
  subnets            = ["subnet-abasdasd132123", "subnet-abasdasd132123132"]

  access_logs = {
    bucket = "my-nlb-logs"
  }

  tags = {
    Project = "Test"
  }

}
```

## Assumptions

Module is to be used with Terraform > 0.12.

## Examples

* [Application Load Balancer ALB](https://github.com/umotif-public/terraform-aws-alb/tree/master/examples/alb)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [linkedin](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name\_prefix | A prefix used for naming resources. | string | n/a | yes |
| subnets | A list of subnet IDs to attach to the LB. | list(string) | n/a | yes |
| vpc\_id | The VPC ID. | string | n/a | yes |
| access\_logs | An Access Logs block. | map(string) | `{}` | no |
| cidr\_blocks\_redirect | List of CIDR ranges to allow at security group level. Defaults to 0.0.0.0/0 | list(string) | `[ "0.0.0.0/0" ]` | no |
| description | The description of the all resources. | string | `"Managed by Terraform"` | no |
| enable\_cross\_zone\_load\_balancing | If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. | bool | `"false"` | no |
| enable\_deletion\_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. | bool | `"false"` | no |
| enable\_http2 | Indicates whether HTTP/2 is enabled in application load balancers. | bool | `"true"` | no |
| enable\_http\_to\_https\_redirect | Enable default redirect rule from port 80 to 443. | bool | `"false"` | no |
| idle\_timeout | (Optional) The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. | number | `"60"` | no |
| internal | Provision an internal load balancer. Defaults to false. | bool | `"false"` | no |
| ip\_address\_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | string | `"ipv4"` | no |
| load\_balancer\_create\_timeout | Timeout value when creating the ALB. | string | `"15m"` | no |
| load\_balancer\_delete\_timeout | Timeout value when deleting the ALB. | string | `"15m"` | no |
| load\_balancer\_type | Type of load balancer to provision (network or application). | string | `"application"` | no |
| load\_balancer\_update\_timeout | Timeout value when updating the ALB. | string | `"15m"` | no |
| subnet\_mapping | A list of subnet mapping blocks describing subnets to attach to network load balancer | list(map(string)) | `[]` | no |
| tags | A map of tags (key-value pairs) passed to resources. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the load balancer. |
| arn\_suffix | The ARN suffix for use with CloudWatch Metrics. |
| dns\_name | The DNS name of the load balancer. |
| name | The name of the load balancer. |
| origin\_id | First part of the DNS name of the load balancer. |
| security\_group\_id | The ID of the security group. |
| zone\_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.
