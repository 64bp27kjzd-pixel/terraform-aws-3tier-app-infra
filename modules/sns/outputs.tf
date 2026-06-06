output "sns_topic_arn" {
  value = aws_sns_topic.send_to_email_topic.arn
}
