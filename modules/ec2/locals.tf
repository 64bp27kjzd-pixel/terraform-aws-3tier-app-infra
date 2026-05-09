locals {
  ec2_name = "${var.name_prefix}-ec2"
  sg_name  = "${var.name_prefix}-ec2-sg"
  lt_name  = "${var.name_prefix}-lt"
  asg_name = "${var.name_prefix}-asg"
}