output "alb_dns" {
  value = module.compute.alb_dns
}

output "rds_endpoint" {
  value = module.db.db_instance_endpoint
}

output "alarm_names" {
  description = "List of all CloudWatch alarm names for EC2 instances"
  value       = module.monitoring.alarm_names
}

