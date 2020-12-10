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
# resource "aws_eip" "main" {
#   count = length(module.vpc.public_subnets)

#   vpc = true
# }

#####
# Network Load Balancer with Elastic IPs attached
#####
module "nlb" {
  source = "../../"

  name_prefix = "complete-nlb-example"

  load_balancer_type = "network"

  vpc_id  = data.aws_vpc.default.id
  subnets = data.aws_subnet_ids.all.ids

  //  Use `subnet_mapping` to attach EIPs and comment out `subnets`
  // subnet_mapping = [for i, eip in aws_eip.main : { allocation_id : eip.id, subnet_id : tolist(module.vpc.public_subnets)[i] }]
  tags = {
    Project = "Test"
  }

}
