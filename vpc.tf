module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "givelify-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  manage_default_security_group  = true
  default_security_group_ingress = [{ "from_port" : 80, "to_port" : 80, "protocol" : "tcp", "cidr_blocks" : "0.0.0.0/0" }]
  default_security_group_egress  = [{ "from_port" : 0, "to_port" : 0, "protocol" : -1, "cidr_blocks" : "0.0.0.0/0" }]

  tags = {
    Name        = "givelify-vpc"
    Environment = var.env
  }
}
