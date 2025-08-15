terraform {
  backend "s3" {
    bucket         = "3tier-dev-report-app-storage"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "3tier-dev-report-app-storage"
    encrypt        = true
  }
}