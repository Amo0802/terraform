variable "ami_id" {
  type        = string
}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
