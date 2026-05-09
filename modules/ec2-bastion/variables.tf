variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "alb_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}