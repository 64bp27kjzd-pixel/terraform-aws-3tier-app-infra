variable "env" {
  type        = string
  description = "環境名"
}

variable "alb_arn" {
  type        = string
  description = "アクセスログを保存する対象のALB ARN"
}