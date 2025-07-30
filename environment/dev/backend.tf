terraform {
  backend "s3" {
    bucket         = "3tier-dev-app-storage"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "3tier-dev-app-storage"
    encrypt        = true
  }
}