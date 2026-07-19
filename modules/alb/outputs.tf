output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

# フルARN（ASGのtarget_group_arnsに使用）
output "alb_tg_arn" {
  value = aws_lb_target_group.this.arn
}

# arn_suffix（CloudWatchアラームのdimensionsに使用）
output "alb_tg_arn_suffix" {
  value = aws_lb_target_group.this.arn_suffix
}

output "alb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}