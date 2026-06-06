variable "send_email" {
  type = string
  description = "CloudWatchアラーム通知の送信先メールアドレス"
}

variable "env" {
  type = string
  description = "環境名"
}