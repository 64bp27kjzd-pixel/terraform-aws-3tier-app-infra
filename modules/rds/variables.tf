variable "name_prefix" {
  type = string
  description = "リソース名のプレフィックス"
}

variable "common_tags" {
  type = map(string)
  description = "全リソースに付与する共通タグ"
}

variable "vpc_id" {
  type = string
  description = "RDSを配置するVPCのID"
}

variable "ec2_sg_id" {
  type = string
  description = "RDSへのアクセスを許可するEC2のセキュリティグループID"
}

variable "subnet_ids" {
  type = list(string)
  description = "RDSを配置するサブネットIDのリスト (マルチAZ構成の場合は複数指定)"
}

variable "username" {
  type = string
  description = "RDSのマスターユーザー名"
}

variable "password" {
  type = string
  description = "RDSのマスターパスワード"
}

variable "vpc_cidr" {
  type = string
  description = "VPCのCIDRブロック"
}

variable "engine" {
  type = string
  description = "DBエンジン"
}

variable "engine_version" {
  type = string
  description = "DBエンジンのバージョン"
}

variable "instance_class" {
  type = string
  description = "RDSインスタンスクラス"
}

variable "allocated_storage" {
  type = number
  description = "RDSに割り当てるストレージ容量 (GB)"
}

variable "multi_az" {
  type = bool
  default = false
  description = "trueの場合、マルチAZ構成でRDSを作成する"
}

variable "skip_final_snapshot" {
  type = bool
  default = true
  description = "trueの場合、RDS削除時にスナップショットを作成しない。本番環境ではfalse推奨"
}

variable "backup_retention_period" {
  type = number
  default = 0
  description = "自動バックアップの保持日数 (0で無効、本番環境では7以上推奨)"
}