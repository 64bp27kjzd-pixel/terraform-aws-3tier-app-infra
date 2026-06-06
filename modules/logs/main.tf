# ==================================================
# CloudWatch Log Groups
# ==================================================

resource "aws_cloudwatch_log_group" "messages" {
  name              = "/${var.env}/ec2/messages"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.env
  }
}

resource "aws_cloudwatch_log_group" "httpd_access" {
  name              = "/${var.env}/ec2/httpd/access"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.env
  }
}

resource "aws_cloudwatch_log_group" "httpd_error" {
  name              = "/${var.env}/ec2/httpd/error"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.env
  }
}

# ==================================================
# VPC Flow Logs
# ==================================================
resource "aws_cloudwatch_log_group" "vpc_flow" {
  for_each = var.enable_vpc_flow_logs ? { enabled = true } : {}

  name              = "/${var.env}/vpc/flowlogs"
  retention_in_days = var.log_retention_days

  tags = {          
    Environment = var.env
  }
}

# ==================================================
# Flow Logs IAM Role
# ==================================================

resource "aws_iam_role" "flowlogs" {
  for_each = var.enable_vpc_flow_logs ? { enabled = true } : {}

  name = "${var.env}-flowlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "flowlogs" {
  for_each = var.enable_vpc_flow_logs ? { enabled = true } : {}
  role     = aws_iam_role.flowlogs["enabled"].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = [
        aws_cloudwatch_log_group.vpc_flow["enabled"].arn,
        "${aws_cloudwatch_log_group.vpc_flow["enabled"].arn}:*"
      ]
    }]
  })
}

# ==================================================
# VPC Flow Logs
# ==================================================
resource "aws_flow_log" "this" {
  for_each = var.enable_vpc_flow_logs ? { enabled = true } : {}

  vpc_id = var.vpc_id

  traffic_type = "ALL"

  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow["enabled"].arn

  iam_role_arn = aws_iam_role.flowlogs["enabled"].arn
}