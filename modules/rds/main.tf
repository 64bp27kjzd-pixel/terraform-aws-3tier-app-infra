# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "rds" {
  name = local.sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, {
  Name = local.sg_name
  })
}

# ----------------------
# RDS
# ----------------------
resource "aws_db_subnet_group" "this" {
  name = local.rds_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {
  Name = local.rds_name
  })
}

resource "aws_db_instance" "this" {
  identifier = local.rds_name
  engine = var.engine
  engine_version = var.engine_version
  auto_minor_version_upgrade = true
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage

  # 認証情報
  username = var.username
  password = var.password

  # ネットワーク設定
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name = aws_db_subnet_group.this.name

  multi_az = true
  skip_final_snapshot = true

  tags = merge(var.common_tags, {
  Name = local.rds_name
  })
}