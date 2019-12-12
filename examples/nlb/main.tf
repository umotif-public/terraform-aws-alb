provider "aws" {
  region = "eu-west-1"
}

#####
# VPC and subnets
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = "simple-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false

  tags = {
    Environment = "test"
  }
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

  name_prefix = "complete-example"

  load_balancer_type = "network"

  vpc_id = module.vpc.vpc_id

  subnets = flatten([module.vpc.public_subnets])

  //  Use `subnet_mapping` to attach EIPs and comment out `subnets`
  // subnet_mapping = [for i, eip in aws_eip.main : { allocation_id : eip.id, subnet_id : tolist(module.vpc.public_subnets)[i] }]
  tags = {
    Project = "Test"
  }

}
