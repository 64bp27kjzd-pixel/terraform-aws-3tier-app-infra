variable "env" {
  type = string
  description = "環境名"
}

variable "enable_alb_logs" {
  type = bool
  description = "trueの場合、ALBアクセスログ用のロググループを作成する"
}

variable "enable_vpc_flow_logs" {
  type = bool
  description = "trueの場合、VPC Flow Logs用のロググループ・IAMロール・フローログを作成する"
}

variable "enable_rds_audit_logs" {
  type = bool
  description = "trueの場合、RDS監査ログ用のロググループを作成する"
}

variable "log_retention_days" {
  type = number
  description = "CloudWatch Logsのログ保持日数"
}

variable "sns_email" {
  type = string
  description = "アラーム通知の送信先メールアドレス"
}

variable "vpc_id" {
  type = string
  description = "VPC Flow Logsを有効化する対象のVPC ID"
}