resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each            = toset(var.instance_ids)

  alarm_name          = "HighCPUUtilization-${each.value}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high CPU usage"
  dimensions = {
    InstanceId = each.value
  }
  alarm_actions = []
}

