# DevOps Project: Terraform Infrastructure with Jenkins CI/CD

This repository contains Terraform infrastructure code with automated deployment using Jenkins pipeline, following GitFlow branching strategy and comprehensive CI/CD practices.

## Prerequisites

Before starting, ensure you have the following installed and configured:

### Required Software
- **Git** (v2.30+)
- **Terraform** (v1.0+)
- **Jenkins** (v2.400+)
- **AWS CLI** (v2.0+) 

### Jenkins Plugins
- Pipeline Plugin
- Git Plugin
- Terraform Plugin
- AWS Credentials Plugin


### Access Requirements
- AWS Account with appropriate IAM permissions
- Git repository access 
- Jenkins server with admin access
- S3 bucket for Terraform state storage

## Repository Structure

```
├── backend.tf               
├── main.tf                   
├── provider.tf              
├── variables.tf             
├── outputs.tf                 
├── terraform.tfvars   
├── .gitignore                           
├── README.md              
├── modules/                   # 
│   ├── compute/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── user_data.ps1
│   ├── database/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── monitoring/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── networking/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf

```

## Git Workflow and Branching Strategy

This project follows **GitFlow** branching model with additional DevOps best practices.

### Branch Types

#### Main Branches
- **`main`** (Production)
  - Contains production-ready code
  - Protected branch with strict rules
  - Requires pull request reviews
  - Automatically deploys to production
  - No direct commits allowed


### 1. Initial Repository Setup

```bash
# Clone the repository
git clone <repository-url>
cd <repository-name>

# Set up Git configuration
git config user.name "Your Name"
git config user.email "your.email@company.com"

# Install pre-commit hooks (optional but recommended)
pip install pre-commit
pre-commit install


### 3. Local Development Setup

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt -recursive

# Run security scan (if tfsec is installed)
tfsec .

# Plan infrastructure changes
terraform plan -var-file="environments/dev.tfvars"
```

### 4. Feature Development Workflow

```bash
# Start new feature
git checkout develop
git pull origin develop


# Make changes and commit
git add .
git commit -m ""

- Add CloudWatch alarms for CPU and memory
- Configure SNS notifications
- Update monitoring module


### 5. Release Workflow

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Update version numbers and changelog
echo "v1.2.0" > VERSION
git add VERSION
git commit -m " v1.2.0"

# Push release branch
git push -u origin release/v1.2.0

# Create PR to main for production deployment
# After testing, merge to main and develop
```



## Jenkins Setup

### 1. Configure Global Credentials

Navigate to `Manage Jenkins > Manage Credentials > Global` and add:

#### AWS Credentials
```
Kind: AWS Credentials
ID: aws-credentials
Description: AWS credentials for Terraform
Access Key ID: [Your AWS Access Key]
Secret Access Key: [Your AWS Secret Key]
```

#### Git Credentials
```
Kind: Username with password
ID: git-credentials  
Description: Git repository access
Username: [Your Git Username]
Password: [Your Git Token/Password]
```

#### Terraform Cloud Token (if using)
```
Kind: Secret text
ID: terraform-cloud-token
Description: Terraform Cloud API token
Secret: [Your Terraform Cloud Token]
```

### 2. Configure Global Tools

Navigate to `Manage Jenkins > Global Tool Configuration`:

#### Terraform Installation
```
Name: Terraform-Latest
Install automatically: Yes
Version: Latest
```

#### Git Installation
```
Name: Default
Path to Git executable: git


## Pipeline Configuration

### Environment Variables in Jenkins

Configure these in `Manage Jenkins > Configure System > Global Properties`:


pipeline {
    agent any
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Environment to deploy'
        )
        booleanParam(
            name: 'DESTROY',
            defaultValue: false,
            description: 'Destroy infrastructure instead of applying'
        )
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        // Additional stages...
    }
    
    post {
        always {
            cleanWs()
        }
        
    }
}
```

## Multi-Environment Support

### Environment Configuration Files

Create separate variable files for each environment:


### Deployment Strategy

- **Development**: Automatic deployment on merge to `develop`
- **Staging**: Automatic deployment on merge to `release/*`
- **Production**: Manual approval required, deployed from `main`



### Common Git Issues

#### Merge Conflicts
```bash
# Resolve merge conflicts
git status
# Edit conflicted files
git add .
git commit -m "resolve: merge conflict in terraform configuration"
```

#### Reset Branch to Remote
```bash
# Reset local branch to match remote
git fetch origin
git reset --hard origin/main
```

```

#### Backend Initialization Errors
```bash
# Reconfigure backend
terraform init -reconfigure

# Migrate state to new backend
terraform init -migrate-state
```

### Jenkins Pipeline Issues

#### Permission Errors
- Verify Jenkins service account has proper IAM permissions
- Check credential configuration in Jenkins
- Ensure Terraform binary is in PATH

#### Build Failures
- Review Jenkins console output
- Check Terraform logs with TF_LOG=DEBUG
- Verify variable file syntax

### Debug Commands

```bash
# Enable detailed Terraform logging
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log

# Validate all Terraform files
find . -name "*.tf" -exec terraform validate {} \;

# Check Terraform state
terraform show
terraform state list

# Format all Terraform files
terraform fmt -recursive .

# Security scan
tfsec . --format json > security-report.json
```

