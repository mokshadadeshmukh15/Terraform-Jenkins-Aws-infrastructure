output "alb_dns_name" {
  description = "Internal DNS name of the Application Load Balancer"
  value       = aws_lb.internal.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID associated with the ALB"
  value       = var.alb_sg_id
}

output "launch_template_id" {
  description = "ID of the EC2 Launch Template"
  value       = aws_launch_template.windows.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.internal.arn
}

output "alb_dns" {
  description = "DNS name of the internal ALB"
  value       = aws_lb.internal.dns_name
}

