variable "name_prefix" {
  type        = string
  description = "リソース名のプレフィックス"
}

variable "common_tags" {
  type        = map(string)
  description = "全リソースに付与する共通タグ"
}

variable "vpc_id" {
  type        = string
  description = "ALBを配置するVPCのID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ALBを配置するパブリックサブネットIDのリスト (複数AZ必須)"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "trueの場合、ALBの誤削除を防ぐ削除保護を有効にする"
}

variable "alb_logs_bucket" {
  type        = string
  description = "ALBアクセスログの保存先S3バケット名"
}

variable "health_check_path" {
  type        = string
  description = "ALBヘルスチェックのパス"
}

variable "s3_bucket_arn" {
  description = "ALBアクセスログ保存先S3バケットのARN"
  type        = string
}