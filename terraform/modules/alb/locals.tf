locals {
  alb_name = "${var.name_prefix}-alb"
  sg_name  = "${var.name_prefix}-alb-sg"
  tg_name  = "${var.name_prefix}-tg"
}