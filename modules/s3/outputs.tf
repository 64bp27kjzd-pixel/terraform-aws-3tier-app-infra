output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_logs.id
}

output "bucket_arn" {
  value = aws_s3_bucket.alb_logs.arn
}