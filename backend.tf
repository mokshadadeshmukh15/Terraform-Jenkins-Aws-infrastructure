terraform {
  backend "s3" {
    bucket         = "my-tf-remote-state-new34567"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
