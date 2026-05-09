variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "health_check_path" {
  type = string
}

variable "ec2_instance" {
 type = list(string) 
}

variable "ec2_sg_id" {
  type = string
}