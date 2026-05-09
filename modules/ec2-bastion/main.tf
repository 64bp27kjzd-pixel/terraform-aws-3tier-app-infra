# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "ec2" {
  name = local.sg_name
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [var.alb_sg_id]
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
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "MyRole"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "MyInstanceProfile"
  role = aws_iam_role.this.name
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# ----------------------
# EC2
# ----------------------
resource "aws_instance" "this" {
  count = length(var.private_subnet_ids)

  ami = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile = aws_iam_instance_profile.this.name

  user_data = <<-EOF
  #!/bin/bash
  dnf update -y
  dnf install -y httpd

  systemctl start httpd
  systemctl enable httpd

  echo "Hello from EC2" > /var/www/html/index.html
  EOF

  tags = merge(var.common_tags, {
  Name = local.ec2_name
  })
}