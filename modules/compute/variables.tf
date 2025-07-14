variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where EC2 instances will be launched"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID for the Application Load Balancer"
}

variable "web_sg_ids" {
  type        = list(string)
  description = "Security Group IDs to associate with the EC2 instances"
}

variable "key_name" {
  type        = string
  description = "Key pair name to access EC2 instances"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the target group"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM Instance Profile name to attach to EC2 instances"
}

