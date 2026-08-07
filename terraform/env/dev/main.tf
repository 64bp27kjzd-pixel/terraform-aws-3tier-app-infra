# ----------------------
# VPC
# ----------------------
module "vpc" {
  source = "../../modules/vpc"

  name_prefix        = local.name_prefix
  common_tags        = local.common_tags
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = var.enable_nat_gateway
}

# ----------------------
# S3 (ALBアクセスログ用)
# ----------------------
module "s3" {
  source = "../../modules/s3"

  env     = var.env
  alb_arn = module.alb.alb_arn
}

# ----------------------
# ALB
# ----------------------
module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  alb_logs_bucket            = module.s3.alb_logs_bucket
  health_check_path          = var.health_check_path
  s3_bucket_arn              = module.s3.bucket_arn
}

# ----------------------
# EC2
# ----------------------
module "ec2" {
  source = "../../modules/ec2"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
  env         = var.env

  alb_sg_id            = module.alb.alb_sg_id
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  instance_type        = var.instance_type
  alb_tg_arns          = [module.alb.alb_tg_arn]
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
}

# ----------------------
# RDS
# ----------------------
module "rds" {
  source = "../../modules/rds"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  ec2_sg_id         = module.ec2.ec2_sg_id
  username          = var.username
  password          = var.password
  vpc_cidr          = var.vpc_cidr
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  multi_az                = var.multi_az
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
}

# ----------------------
# SNS
# ----------------------
module "sns" {
  source = "../../modules/sns"

  send_email = var.send_email
  env        = var.env
}

# ----------------------
# CloudWatch Logs
# ----------------------
module "logs" {
  source = "../../modules/logs"

  env                   = var.env
  enable_alb_logs       = var.enable_alb_logs
  enable_vpc_flow_logs  = var.enable_vpc_flow_logs
  enable_rds_audit_logs = var.enable_rds_audit_logs
  log_retention_days    = var.log_retention_days
  sns_email             = var.send_email
  vpc_id                = module.vpc.vpc_id
}

# ----------------------
# CloudWatch Alarms
# ----------------------
module "alarms" {
  source = "../../modules/alarm"

  env           = var.env
  sns_topic_arn = module.sns.sns_topic_arn

  asg_name                 = module.ec2.asg_name
  alb_arn                  = module.alb.alb_arn_suffix
  alb_tg_arn               = module.alb.alb_tg_arn_suffix
  db_instance_identifier   = module.rds.db_instance_identifier
  db_connections_threshold = var.db_connections_threshold
  nat_gw_ids = {
    "az-a" = module.vpc.nat_gw_ids[0]
  }
}