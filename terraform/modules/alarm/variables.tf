variable "env" {
  type        = string
  description = "環境名"
}

variable "asg_name" {
  type        = string
  description = "監視対象のAuto ScalingグループName"
}

variable "sns_topic_arn" {
  type        = string
  description = "アラーム通知の送信先SNS TopicのARN"
}

variable "alb_arn" {
  type        = string
  description = "監視対象ALBのARNサフィックス (CloudWatchディメンション用)"
}

variable "alb_tg_arn" {
  type        = string
  description = "監視対象ターゲットグループのARNサフィックス (CloudWatchディメンション用)"
}

variable "db_connections_threshold" {
  type        = number
  description = "RDS接続数アラームの閾値"
}

variable "nat_gw_ids" {
  type        = map(string)
  description = "監視対象NAT GatewayのAZとIDのマップ "
}

variable "cpu_utilization_threshold" {
  type        = number
  default     = 80
  description = "RDS CPUアラームの閾値 (%)"
}

variable "free_storage_space_threshold" {
  type        = number
  default     = 10737418240
  description = "RDS空きストレージアラームの閾値 (バイト)"
}

variable "freeable_memory_threshold" {
  type        = number
  default     = 256000000 # 256 MB
  description = "RDSのFreeableMemoryアラーム閾値(バイト単位)"
}

variable "db_instance_identifier" {
  type = string
}