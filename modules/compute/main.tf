# Data block to get latest Windows Server 2019 AMI
data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"] # Amazon's Windows AMIs

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

# Launch template for Windows IIS
resource "aws_launch_template" "windows" {
  name_prefix   = "iis-win-lt-"
  image_id      = data.aws_ami.windows.id
  instance_type = "t3.medium"
  key_name      = var.key_name

  user_data = base64encode(file("${path.module}/user_data.ps1"))

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    security_groups = var.web_sg_ids
  }
}

# Internal Application Load Balancer
resource "aws_lb" "internal" {
  name               = "iis-alb-dev"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [var.alb_sg_id]
}

# Target Group for ALB
resource "aws_lb_target_group" "web" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Auto Scaling Group for launching EC2 instances from LT
resource "aws_autoscaling_group" "web_asg" {
  name                      = "iis-asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 2
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.web.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.windows.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "iis-web-server"
    propagate_at_launch = true
  }
}

