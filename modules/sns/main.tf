# SNS Topicの作成
resource "aws_sns_topic" "send_to_email_topic" {
  name = "send_to_email_topic"
}

# SNS Subscription
resource "aws_sns_topic_subscription" "send_to_email_subscription" {
  topic_arn = aws_sns_topic.send_to_email_topic.arn
  protocol  = "email" 
  endpoint  = var.send_email
}