# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "ec2" {
  name   = local.sg_name
  vpc_id = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = local.sg_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------
# IAM Policy
# ----------------------
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = local.instance_profile_name
  role = aws_iam_role.this.name
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ----------------------
# Launch Template
# ----------------------
resource "aws_launch_template" "this" {
  name = local.lt_name
  update_default_version = true

  image_id      = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type

  # Security Group
  vpc_security_group_ids = [aws_security_group.ec2.id]

  # IAM Role
  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  # UserData
  user_data = base64encode(<<-EOF
#!/bin/bash
dnf update -y
dnf install -y httpd

systemctl start httpd
systemctl enable httpd

echo "Hello from EC2" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = local.ec2_name
    })
  }
}

# ----------------------
# Auto Scaling Group
# ----------------------
resource "aws_autoscaling_group" "this" {
  name = local.asg_name
  
  # EC2をスケーリングする数
  max_size         = var.asg_max_size
  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity

  # ヘルスチェック
  health_check_grace_period = 300
  health_check_type         = "ELB"

  # VPC指定
  vpc_zone_identifier = var.private_subnet_ids

  # ターゲットグループ指定
  target_group_arns = var.alb_tg_arns

  # 起動テンプレートとインスタンスタイプ指定
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
    }
  }
}