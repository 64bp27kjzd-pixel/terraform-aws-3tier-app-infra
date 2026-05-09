resource "aws_security_group" "ec2" {
  name   = "${var.name}-ec2-app-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-ec2-app-sg"
  }
}

# ALBからのHTTPのみ許可
resource "aws_security_group_rule" "ec2_from_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ec2.id
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

# EC2 outbound
resource "aws_security_group_rule" "ec2_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ec2.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "this" {
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name = var.key_name

  associate_public_ip_address = var.associate_private_ip

  user_data = var.user_data

  tags = {
    Name = "${var.name}-ec2-app"
  }
}