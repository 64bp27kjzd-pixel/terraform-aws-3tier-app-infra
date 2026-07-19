# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "rds" {
  name   = local.sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  tags = merge(var.common_tags, {
    Name = local.sg_name
  })
}

# ----------------------
# RDS
# ----------------------
resource "aws_db_subnet_group" "this" {
  name       = local.rds_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {
    Name = local.rds_name
  })
}

resource "aws_db_instance" "this" {
  identifier                 = local.rds_name
  engine                     = var.engine
  engine_version             = var.engine_version
  auto_minor_version_upgrade = true
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage

  # 認証情報
  username = var.username
  password = var.password

  # ネットワーク設定
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  multi_az            = var.multi_az
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier != null ? var.final_snapshot_identifier : "${local.rds_name}-final"
  backup_retention_period = var.backup_retention_period

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }

  tags = merge(var.common_tags, {
    Name = local.rds_name
  })
}