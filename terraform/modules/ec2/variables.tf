variable "name_prefix" {
  type        = string
  description = "リソース名のプレフィックス"
}

variable "common_tags" {
  type        = map(string)
  description = "全リソースに付与する共通タグ"
}

variable "alb_sg_id" {
  type        = string
  description = "EC2へのアクセスを許可するALBのセキュリティグループID"
}

variable "vpc_id" {
  type        = string
  description = "EC2を配置するVPCのID"
}

variable "asg_min_size" {
  type        = number
  default     = 2
  description = "ASGで維持する最小EC2インスタンス数"
}

variable "asg_max_size" {
  type        = number
  default     = 2
  description = "ASGでスケールアウトできる最大EC2インスタンス数"
}

variable "asg_desired_capacity" {
  type        = number
  default     = 2
  description = "ASGが通常時に維持するEC2インスタンス数"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "EC2を配置するプライベートサブネットIDのリスト"
}

variable "instance_type" {
  type        = string
  description = "EC2インスタンスタイプ"
}

variable "alb_tg_arns" {
  type        = list(string)
  description = "ASGに関連付けるALBターゲットグループARNのリスト"
}

variable "env" {
  type        = string
  description = "環境名"
}