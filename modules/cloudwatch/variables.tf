variable "env" {
  type = string
}

variable "ec2_instance_ids" {
  type = list(string)
}

variable "sns_topic_arn" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "alb_tg_arn" {
  type = string
}

variable "db_instance_id" {
  type = string
}

variable "db_connections_threshold" {
  type = number
}

variable "nat_gw_id" {
  type = string
}