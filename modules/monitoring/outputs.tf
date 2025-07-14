output "alarm_names" {
  description = "List of CloudWatch alarm names for all EC2 instances"
  value       = [for alarm in aws_cloudwatch_metric_alarm.high_cpu : alarm.alarm_name]
}


