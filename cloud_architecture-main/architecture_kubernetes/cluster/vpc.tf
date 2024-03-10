module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "vpc-module-demo"
  cidr = "100.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24"]
  public_subnets  = ["100.0.101.0/24", "100.0.102.0/24", "100.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Name = "${var.cluster-name}-vpc"
  }
}