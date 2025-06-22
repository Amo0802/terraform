provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}


# Main VPC
module "main_vpc" {
  source = "./modules/vpc"
  
  vpc_name             = "main-vpc"
  vpc_cidr            = "172.16.0.0/16"
  public_subnet_cidr  = "172.16.1.0/24"
  private_subnet_cidr = "172.16.2.0/24"
  availability_zone   = data.aws_availability_zones.available.names[0]
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Secondary VPC
module "secondary_vpc" {
  source = "./modules/vpc"
  
  vpc_name            = "secondary-vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = data.aws_availability_zones.available.names[0]
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# S3
module "s3_bucket" {
  source = "./modules/s3"
  
  bucket_name = "${var.project_name}-bucket-${random_string.bucket_suffix.result}"
  vpc_endpoint_id = module.vpc_endpoint.vpc_endpoint_id  # Pass VPC endpoint ID
  
  tags = {
    Name        = "main-secure-bucket"
    Environment = var.environment
    Project     = var.project_name
  }
}

# VPC ENDPOINT MODULE
module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"
  
  vpc_id = module.main_vpc.vpc_id
  route_table_ids = [
    module.main_vpc.public_route_table_id,
    module.main_vpc.private_route_table_id
  ]
  s3_bucket_arn = module.s3_bucket.bucket_arn
  aws_region = var.aws_region
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# IAM MODULE FOR EC2 S3 ACCESS
module "iam_s3_access" {
  source = "./modules/iam"
  
  project_name = var.project_name
  s3_bucket_arn = module.s3_bucket.bucket_arn
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Public EC2 instance in main VPC with S3 access
module "public_ec2" {
  source = "./modules/ec2"

  ami_id                  = data.aws_ami.amazon_linux.id
  instance_name           = "public-server-with-s3"
  subnet_id               = module.main_vpc.public_subnet_id
  security_group_ids      = [module.main_vpc.public_security_group_id]
  key_name                = var.key_name
  instance_type           = var.instance_type
  iam_instance_profile    = module.iam_s3_access.instance_profile_name

  tags = {
    Type        = "Public"
    HasS3Access = "true"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Private EC2 instance in main VPC
module "private_ec2" {
  source = "./modules/ec2"

  ami_id                  = data.aws_ami.amazon_linux.id
  instance_name           = "private-server"
  subnet_id               = module.main_vpc.private_subnet_id
  security_group_ids      = [module.main_vpc.private_security_group_id]
  key_name                = var.key_name
  instance_type           = var.instance_type

  tags = {
    Type        = "Private"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Public EC2 instance in secondary VPC
module "secondary_public_ec2" {
  source = "./modules/ec2"

  ami_id                  = data.aws_ami.amazon_linux.id
  instance_name           = "secondary-public-server"
  subnet_id               = module.secondary_vpc.public_subnet_id
  security_group_ids      = [module.secondary_vpc.public_security_group_id]
  key_name                = var.key_name
  instance_type           = var.instance_type

  tags = {
    Type        = "Public"
    VPC         = "Secondary"
    Environment = var.environment
    Project     = var.project_name
  }
}

# VPC PEERING
module "vpc_peering" {
  source = "./modules/vpc-peering"
  
  main_vpc_id          = module.main_vpc.vpc_id
  secondary_vpc_id     = module.secondary_vpc.vpc_id
  main_vpc_cidr        = "172.16.0.0/16"
  secondary_vpc_cidr   = "10.0.0.0/16"
  main_route_table_ids = [
    module.main_vpc.public_route_table_id,
    module.main_vpc.private_route_table_id
  ]
  secondary_route_table_ids = [module.secondary_vpc.public_route_table_id]
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}