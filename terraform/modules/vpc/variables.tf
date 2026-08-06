variable "name_prefix" {
  type = string
  description = "リソース名のプレフィックス"
}

variable "common_tags" {
  type = map(string)
  description = "全リソースに付与する共通タグ"
}

variable "vpc_cidr" {
  type = string
  description = "VPCのCIDRブロック"
}

variable "azs" {
  type = list(string)
  description = "使用するアベイラビリティゾーンのリスト"
}

variable "single_nat_gateway" {
  type = bool
  default = false
  description = "trueの場合、NAT Gatewayを1つのみ作成し全プライベートサブネットで共有する。falseの場合はAZごとに1つ作成する"
}