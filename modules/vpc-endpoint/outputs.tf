output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "vpc_endpoint_arn" {
  description = "ARN of the VPC endpoint"
  value       = aws_vpc_endpoint.s3.arn
}