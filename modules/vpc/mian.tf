module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.18.1"

  # name = var.name this has been deprecated, using tags rather than name
  cidr = var.vpc_cidr
  azs = var.azs
  public_subnets = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  map_public_ip_on_launch = true

  tags = var.tags

}