########################################
# CloudWatch Log Group
########################################

resource "aws_cloudwatch_log_group" "application" {

  name = "/three-tier/application"

  retention_in_days = 30
}

########################################
# CPU Alarm
########################################

resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "High-CPU"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_description = "High CPU Utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}
