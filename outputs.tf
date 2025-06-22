# VPC Outputs
output "main_vpc_id" {
  description = "ID of the main VPC"
  value       = module.main_vpc.vpc_id
}

output "secondary_vpc_id" {
  description = "ID of the secondary VPC"
  value       = module.secondary_vpc.vpc_id
}

# EC2 Outputs
output "public_server_ip" {
  description = "Public IP of main VPC public server"
  value       = module.public_ec2.public_ip
}

output "public_server_url" {
  description = "URL to access the public server"
  value       = "http://${module.public_ec2.public_ip}"
}

output "private_server_ip" {
  description = "Private IP of main VPC private server"
  value       = module.private_ec2.private_ip
}

output "secondary_public_server_ip" {
  description = "Public IP of secondary VPC public server"
  value       = module.secondary_public_ec2.public_ip
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_bucket.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

# VPC Endpoint Outputs
output "vpc_endpoint_id" {
  description = "ID of the S3 VPC endpoint"
  value       = module.vpc_endpoint.vpc_endpoint_id
}

# VPC Peering Outputs
output "vpc_peering_connection_id" {
  description = "VPC peering connection ID"
  value       = module.vpc_peering.peering_connection_id
}

# IAM Outputs
output "ec2_iam_role_arn" {
  description = "ARN of the EC2 IAM role for S3 access"
  value       = module.iam_s3_access.role_arn
}

# Summary Output
output "infrastructure_summary" {
  description = "Summary of created infrastructure"
  value = {
    main_vpc_id     = module.main_vpc.vpc_id
    secondary_vpc_id = module.secondary_vpc.vpc_id
    public_server_url = "http://${module.public_ec2.public_ip}"
    s3_bucket_name  = module.s3_bucket.bucket_name
    vpc_peering_id  = module.vpc_peering.peering_connection_id
  }
}