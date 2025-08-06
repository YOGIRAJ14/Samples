#In companies there will be 3 different file dev.tfvars, UAT.tfvars, prod.tfvars and thier respective configurations. 
# So it will create 3 vpc's dev, UAT & Prod.

vpc_cidr_block      = "10.0.0.0/16"
subnet_cidr_block   = "10.0.10.0/24"
avail_zone          = "us-east-1a"
env_prefix          = "dev"
instance_type       = "t2.micro"
