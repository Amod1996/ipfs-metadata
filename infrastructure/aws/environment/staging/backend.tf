terraform {
  backend "s3" {
    bucket         = "staging-terraform-state-bucket--usw2-az1--x-s3"
    key            = "staging/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
