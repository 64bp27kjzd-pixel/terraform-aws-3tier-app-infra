variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
  default = false
}

variable "skip_final_snapshot" {
  type = bool
  default = true
}

variable "backup_retention_period" {
  type = number
  default = 0
}