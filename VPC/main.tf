###############################################################################
# EC2 Instance :
###############################################################################

resource "aws_instance" "my_EC2" {
    ami = "ami-0c94855ba95c71c99"  #Take this Amazon Linux AMI ID From AWS Console
    instance_type = "t2.micro"
    availability_zone = "us-east-1"
    key_name =  "my_key"           #Put name of key-pair available as per region.
    vpc_security_group_ids = ""  
    subnet_id = "subnet-0c4d3d4c5d6e7"
    security_groups = [aws_security_group.sg.id]

tags = {
  name= "My-EC2"
  env= "dev"
  Owner = "devops-team"
}
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "myVPC" {
  cidr_block                       = var.cidr
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }
}

###############################################################################
# Internet Gateway
###############################################################################

resource "aws_internet_gateway" "myIGW" {

  vpc_id = aws_vpc.myVPC.id
  tags = {
    "Name" = var.igw_tag
  }
}

################################################################################
# Public subnet
################################################################################

resource "aws_subnet" "public_subnet_1" {
  vpc_id                          = aws_vpc.myVPC.id
  cidr_block                      = var.public_subnets_cidr_1
  availability_zone               = data.aws_availability_zones.available_1.names[0]
  map_public_ip_on_launch         = var.map_public_ip_on_launch         #All EC2 inside this subnet will get Public_ips

  tags = {
   Name = var.public_subnet_tag_1
  }
}

################################################################################
# Database subnet / Private Subnets
################################################################################

resource "aws_subnet" "database_subnet_1" {
  vpc_id                          = aws_vpc.myVPC.id
  cidr_block                      = var.database_subnets_cidr_1
  availability_zone               = data.aws_availability_zones.available_1.names[0] ##REFER TERRAFORM NOTES TO UNDERSTAND THIS
  map_public_ip_on_launch         = false

  tags = {
    Name = var.database_subnet_tag_1
  }
}

################################################################################
# Publiс route table
################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = var.public_route_table_tag
  }
}

#Attaching Public subnet with Internet gateway for internet access
resource "aws_route" "public_internet_gateway" {           #To route IGW to Public subnet only For internet access
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"                     #We will put range for IP range  "0.0.0.0/0" means for all
  gateway_id             = aws_internet_gateway.myIGW.id
}

################################################################################
# Database route table
################################################################################

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = var.database_route_table_tag
  }
}

################################################################################
# Route table association with subnets
################################################################################

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "sg" {
  name        = "tcw_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "tcw_security_group"
  }
}

###############################################################################
# Associate EIP to an EC2 instance
###############################################################################

# Creating an EC2 w/ Nginx_webserver name

resource "aws_instance" "Nat_instance" {
  ami               = "ami-21f78e11"
  availability_zone = "us-west-2a"
  instance_type     = "t2.micro"

  tags = {
    Name = "Nat_instance_server"
  }
}

# Just creating EIP 

resource "aws_eip" "EIP_for_NAT" {
  domain = "vpc"                      #gives extra info to AWS.The domain value must be "vpc" if you're working inside a Virtual Private Cloud (which most EC2 setups do nowadays). It ensures that the IP is compatible with your EC2 instance hosted in a VPC.
}

# Allocation of Elastic IP w/ Nat_instance_server

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Nat_instance.id
  allocation_id = aws_eip.EIP_for_NAT.id
}
