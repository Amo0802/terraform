variable "vpc_id" {
  description = "VPC ID where the endpoint will be created"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with the endpoint"
  type        = list(string)
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for policy"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}