pipeline {
  agent { label 'terraform_prod' }
  environment {
    TF_VAR_aws_access_key = credentials('aws_access_key')
    TF_VAR_aws_secret_key = credentials('aws_secret_key') 
    TF_VAR_aws_region = 'us-east-1'
  }
  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -var-file=terraform.tfvars'
      }
    }

    stage('Terraform Apply') {
      steps {
        input "Apply Changes?"
        sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
      }
    }
  }
}
