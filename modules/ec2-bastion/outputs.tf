output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}

output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}