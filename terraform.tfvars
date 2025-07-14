vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-vpc"
cidr_public_subnet   = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
key_name             = "aws_infra_terraform_task-new"
db_username          = "admin"
db_password          = "mypass12345!"
