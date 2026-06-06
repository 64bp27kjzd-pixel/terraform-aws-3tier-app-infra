# ----------------------
# EC2 CPU使用率監視
# ----------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "${var.env}-asg-${var.asg_name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "EC2 CPU使用率が70%を超過 (${var.asg_name})"
  alarm_actions       = [var.sns_topic_arn]
  
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# ----------------------
# EC2死活監視
# ----------------------
resource "aws_cloudwatch_metric_alarm" "ec2_StatusCheck_alarm" {
  alarm_name          = "${var.env}-ec2-${var.asg_name}-status-check-failed"
  metric_name = "StatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  namespace = "AWS/EC2"
  statistic = "Maximum"
  period = 300
  threshold = 1
  alarm_description = "EC2 ステータスチェック失敗 (${var.asg_name})"
  alarm_actions = [var.sns_topic_arn]
  treat_missing_data = "missing"
  
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# ----------------------
# ALB UnHealthyHostCount
# ----------------------
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_host" {
  alarm_name          = "${var.env}-alb-unhealthy-host"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1

  namespace   = "AWS/ApplicationELB"
  metric_name = "UnHealthyHostCount"
  statistic   = "Average"
  period      = 60

  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.alb_tg_arn
  }

  alarm_description = "Unhealthy host detected"

  alarm_actions = [var.sns_topic_arn]
}

# ----------------------
# ALB HTTPCode_Target_5XX_Count
# ----------------------
resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.env}-alb-5xx-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 5

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"
  statistic   = "Sum"
  period      = 60

  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.alb_tg_arn
  }

  alarm_description = "Too many target 5XX errors"

  alarm_actions = [var.sns_topic_arn]
}

# ----------------------
# ALB TargetResponseTime
# ----------------------
resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  alarm_name          = "${var.env}-alb-response-time-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 1

  namespace   = "AWS/ApplicationELB"
  metric_name = "TargetResponseTime"
  statistic   = "Average"
  period      = 60

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  alarm_description = "ALB target response time too high"

  alarm_actions = [var.sns_topic_arn]
}

# ----------------------
# RDS CPU
# ----------------------
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = "${var.env}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 600
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
  alarm_description   = "Average database CPU utilization over last 10 minutes"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# ----------------------
# RDS 接続数
# ----------------------
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${var.env}-rds-connections-high"
  alarm_description   = "RDS connection count too high"

  namespace   = "AWS/RDS"
  metric_name = "DatabaseConnections"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.db_connections_threshold
  evaluation_periods  = 2
  period              = 60

  statistic = "Average"

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  alarm_actions = [var.sns_topic_arn]

  treat_missing_data = "notBreaching"
}

# ----------------------
# RDS ストレージ
# ----------------------
resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "${var.env}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 600
  statistic           = "Average"
  threshold           = var.free_storage_space_threshold
  alarm_description   = "Average database free storage space over last 10 minutes"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# ----------------------
# RDS メモリ
# ----------------------
resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = "${var.env}-rds-memory-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 600
  statistic           = "Average"
  threshold           = var.freeable_memory_threshold
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# ----------------------
# NAT Gateway ポート不足
# ----------------------
resource "aws_cloudwatch_metric_alarm" "natgw_error_port_allocation" {
  for_each   = var.nat_gw_ids
  alarm_name          = "${var.env}-natgw-${each.value}-port-allocation-error"
  alarm_description   = "NAT Gateway port allocation errors detected"

  namespace   = "AWS/NATGateway"
  metric_name = "ErrorPortAllocation"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = 60

  statistic = "Sum"

  dimensions = {
    NatGatewayId = each.value
  }

  alarm_actions = [var.sns_topic_arn]
}

# ----------------------
# NAT Gateway ドロップしたパケット数
# ----------------------
resource "aws_cloudwatch_metric_alarm" "natgw_packet_drop" {
  for_each = var.nat_gw_ids

  alarm_name          = "${var.env}-natgw-${each.value}-packet-drop"
  alarm_description   = "NAT Gateway packet drops detected"

  namespace   = "AWS/NATGateway"
  metric_name = "PacketsDropCount"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = 60

  statistic = "Sum"

  dimensions = {
    NatGatewayId = each.value
  }

  alarm_actions = [var.sns_topic_arn]
}

