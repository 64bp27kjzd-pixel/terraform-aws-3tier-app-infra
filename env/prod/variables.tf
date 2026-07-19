# ----------------------
# Common
# ----------------------
variable "project_name" {
  type = string
  description = "プロジェクト名。リソース名のプレフィックスに使用される"
}

variable "env" {
  type = string
  description = "環境名"
}

variable "vpc_cidr" {
  type = string
  description = "VPCのCIDRブロック"
}

# ----------------------
# VPC
# ----------------------
variable "azs" {
  type = list(string)
  description = "使用するアベイラビリティゾーンのリスト"
}

variable "enable_nat_gateway" {
  type = bool
  default = false
  description = "trueの場合、NAT Gatewayを作成しプライベートサブネットからのアウトバウンド通信を有効にする"
}

# ----------------------
# ALB
# ----------------------
variable "enable_deletion_protection" {
  type = bool
  default = true
  description = "trueの場合、ALBの誤削除を防ぐ削除保護を有効にする" 
}

variable "health_check_path" {
  type = string
  default = "/"
  description = "ALBヘルスチェックのパス"
}

# ----------------------
# EC2
# ----------------------
variable "instance_type" {
  type = string
  description = "EC2インスタンスタイプ"
}

variable "asg_min_size" {
  type    = number
  default = 3
  description = "ASGの最小インスタンス数"
}

variable "asg_max_size" {
  type    = number
  default = 6
  description = "ASGの最大インスタンス数"
}

variable "asg_desired_capacity" {
  type    = number
  default = 3
  description = "ASGの希望インスタンス数"
}

# ----------------------
# RDS
# ----------------------
variable "engine" {
  type = string
  default = "mysql"
  description = "RDSのDBエンジン"
}

variable "engine_version" {
  type = string
  default = "8.0"
  description = "RDSのDBエンジンバージョン"
}

variable "instance_class" {
  type = string
  description = "RDSインスタンスクラス"
}

variable "allocated_storage" {
  type = number
  default = 10
  description = "RDSに割り当てるストレージ容量 (GB)"
}

variable "username" {
  type = string
  default = "admin"
  description = "RDSのマスターユーザー名"
}

variable "password" {
  type = string
  sensitive = false
  description = "RDSのマスターパスワード"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "trueの場合、RDSをMulti-AZ構成にする"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "RDSの自動バックアップ保持日数(0=無効)"
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
  description = "falseの場合、削除時スナップショット作成"
}

variable "final_snapshot_identifier" {
  type    = string
  default = null
  description = "RDSインスタンス削除時に作成する最終スナップショットの識別子"
}

# ----------------------
# SNS
# ----------------------
variable "send_email" {
  type = string
  description = "CloudWatchアラーム通知の送信先メールアドレス"
}

# ----------------------
# CloudWatch Logs
# ----------------------
variable "enable_alb_logs" {
  type = bool
  default = true
  description = "trueの場合、ALBアクセスログをS3に保存する"
}

variable "enable_vpc_flow_logs" {
  type = bool
  default = true
  description = "trueの場合、VPC Flow LogsをCloudWatch Logsに保存する"
}

variable "enable_rds_audit_logs" {
  type = bool
  default = true
  description = "trueの場合、RDS監査ログをCloudWatch Logsに保存する"
}

variable "log_retention_days" {
  type = number
  default = 30
  description = "CloudWatch Logsのログ保持日数"
}

# ----------------------
# CloudWatch Alarms
# ----------------------
variable "db_connections_threshold" {
  type = number
  default = 50
  description = "RDS接続数アラームの閾値"
}