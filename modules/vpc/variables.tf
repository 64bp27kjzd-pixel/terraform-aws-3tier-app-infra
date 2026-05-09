variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}

