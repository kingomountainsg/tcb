terraform {
  backend "s3" {
    bucket         = "tcb-devops-state-demo-x922xxx"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tcb-devops-state-lock-table"
  }
}
