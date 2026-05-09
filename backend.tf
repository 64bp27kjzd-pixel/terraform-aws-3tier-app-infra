terraform {
  backend "s3" {
    bucket         = "my-terraform-github-actions-test"
    key            = "dev/myapp/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}