variable "main_vpc_id" {
  type = string
}

variable "secondary_vpc_id" {
  type = string
}

variable "main_vpc_cidr" {
  type = string
}

variable "secondary_vpc_cidr" {
  type = string
}

variable "main_route_table_ids" {
  type = list(string)
}

variable "secondary_route_table_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
