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

## License

See LICENSE for full details.