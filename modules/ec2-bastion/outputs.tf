output "ec2_instance_ids" {
  value = aws_instance.this[*].id
}

output "ec2_private_ips" {
  value = aws_instance.this[*].private_ip
}

output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}