variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
  default = null
}

variable "associate_private_ip" {
  type = bool
  default = false
}

variable "name" {
  type = string
}

variable "user_data" {
  type = string
  default = ""
}

variable "app_port" {
  type = string
}