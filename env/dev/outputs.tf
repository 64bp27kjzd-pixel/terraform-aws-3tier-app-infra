output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_cidrs" {
  value = module.vpc.public_cidrs
}

output "private_cidrs" {
  value = module.vpc.private_cidrs
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_zone_id" {
  value = module.alb.alb_dns_name
}

output "ec2_instance_ids" {
  value = module.ec2.ec2_instance_ids
}

output "ec2_public_ips" {
  value = module.ec2.ec2_private_ips
}

output "db_id" {
  value = module.rds.db_id
}