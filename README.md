Project Overview: 
This project provisions a **highly available**, **secure**, and **auditable** AWS infrastructure using **Terraform**, following **Infrastructure as Code (IaC)** best practices. It features modular design, automated CI/CD deployment via Jenkins, and secure resource provisioning.

Scenario: 
You're building foundational infrastructure for a web-based application with the following:

- VPC with public/private subnets
- EC2-based IIS web servers (Windows)
- Internal Application Load Balancer (ALB)
- RDS SQL Server database (private)
- IAM roles and secure access control
- CloudWatch-based monitoring and alerting
- CI/CD pipeline using Jenkins
- Remote backend (S3 + DynamoDB) for state management
- Environment separation (dev/prod)


 Implementation Breakdown: 
 
 1. VPC & Networking Module
 Resources: 
- VPC
- 2 Public Subnets (across 2 AZs)
- 2 Private Subnets (across 2 AZs)
- Internet Gateway
- NAT Gateway
- Public & Private Route Tables

Deployment Strategy:
- Public subnets host NAT Gateway for outbound internet.
- Private subnets house EC2 and RDS for security.
- NAT Gateway allows EC2 in private subnets to update software packages securely.
- Segregated route tables manage internal/external routing explicitly.

 
2. Compute Module (Windows EC2 + IIS)
 Resources: 
- Launch Template for consistency
- 2 EC2 Windows Instances (private subnet)
- Internal Application Load Balancer (ALB)
- Security Groups
- IAM Role for EC2 (with SSM and CloudWatch)

Bootstrap Script:
powershell
Install-WindowsFeature -Name Web-Server
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value "Terraform IIS Server"

Deployment Strategy:
- Launch Template promotes scalable, consistent deployment.
- Internal ALB distributes traffic in private layer.
- SSM Agent enables secure, keyless access to EC2 via Systems Manager.
- CloudWatch Agent allows centralized log shipping.


 3. Database Module (RDS SQL Server)
Resources:
- RDS instance (SQL Server)
- Subnet group (private subnets)
- Secrets Manager for credentials

Configuration:
- Multi-AZ: Disabled
- Storage encryption: Enabled
- Public access: Disabled

Security:
- Only EC2 instances in private subnet can access RDS
- Security group rule restricts access on port 1433 from EC2 SG
- Credentials: Stored in AWS Secrets Manager

4. IAM & Security Module
Role Name: ec2_ssm_role
Attached Policies: AmazonSSMManagedInstanceCore, CloudWatchAgent
Purpose: Enables EC2 instances to use AWS Systems Manager (SSM) for secure access and send logs to CloudWatch.

Role Name: jenkins_role
Attached Policies: Custom policy for Terraform
Purpose: Grants Jenkins the necessary permissions to deploy and manage AWS infrastructure using Terraform.

Role Name: rds_secrets_role
Attached Policies: SecretsManagerReadWrite or SecretsManagerReadAccess
Purpose: Allows EC2 instances to securely fetch RDS database credentials from AWS Secrets Manager.

Security Groups:

EC2 Instance
Ingress Rule: Allow traffic from the ALB on port 80 (HTTP).

Application Load Balancer (ALB)
Ingress Rule: Allow traffic from private subnet CIDRs (or from a bastion host, if used).

RDS (SQL Server)
Ingress Rule: Allow traffic on port 1433 only from the EC2 security group.

Best Practices Applied: 

- Least privilege IAM access
- Secrets stored securely in Secrets Manager (encrypted at rest & in transit)
- No public IPs on core compute/database resources
- Role-based access control across EC2, Jenkins, and RDS

5. Monitoring & Logging Module:
Resources:  
- CloudWatch Logs: Enabled via CloudWatch Agent on EC2
- CloudWatch Alarms: Trigger when CPU > 80%
- CloudWatch Dashboards (optional)


6. Terraform Best Practices
 Modular Structure:
networking, compute, db, iam, monitoring, s3_bucket

Remote State Backend:

terraform {
  backend "s3" {
    bucket         = "my-tf-remote-state-new34567"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}

Environment Separation:

environments/
├── dev/
│   ├── main.tf
│   ├── backend.tf
│   ├── terraform.tfvars
│   ├── variables.tf
├── prod/

Validation & Formatting:
- terraform fmt -recursive
- tflint
- checkov -d .


7. Jenkins CI/CD Integration
- Jenkins Pipeline Setup
- Use Jenkinsfile at repo root.
- Configure AWS credentials (via IAM, environment, or Credentials plugin).
- Install Terraform, Git, Pipeline, and AWS CLI plugins on Jenkins.

Sample Jenkinsfile

pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Terraform Init') {
      steps { sh 'terraform init' }
    }
    stage('Terraform Plan') {
      steps { sh 'terraform plan -var-file=terraform.tfvars' }
    }
    stage('Terraform Apply') {
      steps {
        input "Apply Changes?"
        sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
      }
    }
  }
}

Deployment Steps - 
- cd environments/dev
- terraform init
- terraform plan
- terraform apply

Command Description: 
terraform init - Initialize modules, download providers, setup backend
terraform plan - Preview what changes will be made
terraform apply - Deploy infrastructure to AWS
terraform destroy - Destroy all resources (use with caution)

Project Structure: 
task/
├── backend.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
├── variables.tf
├── Jenkinsfile
└── modules/
    ├── compute/
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── user_data.ps1
    │   └── variables.tf
    ├── db/
    │   ├── main.tf
    │   └── variables.tf
    ├── iam/
    │   └── main.tf
    ├── monitoring/
    │   ├── outputs.tf
    │   └── variables.tf
    └── networking/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf

Security Highlights:
- EC2 & RDS reside in private subnets
- Secrets stored securely in AWS Secrets Manager
- IAM roles follow least privilege
- SSM enabled — no SSH access required
- No public IPs assigned to critical components

Prerequisites:
- Terraform >= 1.4.x
- AWS CLI installed & configured
- Jenkins installed on Ubuntu 22.04
- GitHub repo configured with Jenkins
- S3 bucket & DynamoDB table created for backend

Author:
Your Name - Mokshada Deshmukh
GitHub: https://github.com/mokshadadeshmukh15/Terraform-Jenkins-Aws-infrastructure.git

Summary
You now have:

- Modular, reusable Terraform code
- Secure, private infrastructure with IAM controls
- Jenkins CI/CD pipeline with approval steps
- Monitoring and alerting via CloudWatch
- Environment separation with state locking
