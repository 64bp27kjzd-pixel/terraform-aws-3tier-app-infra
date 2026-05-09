module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = false
}

module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  health_check_path = var.health_check_path
}

module "ec2" {
  source = "../../modules/ec2"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  alb_sg_id            = module.alb.alb_sg_id
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  instance_type        = var.instance_type
  alb_tg_arns          = module.alb.alb_tg_arns
  asg_min_size         = 2
  asg_max_size         = 6
  asg_desired_capacity = 2
}

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

  multi_az                = true
  skip_final_snapshot     = false
  backup_retention_period = 7
}