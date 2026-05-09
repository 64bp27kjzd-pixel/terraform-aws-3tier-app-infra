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

variable "asg_min_size" {
  type = number
  default = 2
}

variable "asg_max_size" {
  type = number
  default = 2
}

variable "asg_desired_capacity" {
  type = number
  default = 2
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "alb_tg_arns" {
  type = list(string)
}