variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
  default = false
}

variable "health_check_path" {
  type = string
  default = "/"
}

variable "instance_type" {
  type = string
}

variable "engine" {
  type = string
  default = "mysql"
}

variable "engine_version" {
  type = string
  default = "8.0"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
  default = 10
}

variable "username" {
  type = string
  default = "admin"
}

variable "password" {
  type = string
  sensitive = false
}