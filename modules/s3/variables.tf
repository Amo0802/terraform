variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "vpc_endpoint_id" {
  description = "VPC Endpoint ID for bucket policy"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}