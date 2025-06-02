provider "aws" {
  region = "us-east-1"
  profile= "admin"
}
terraform {
  backend "s3" {
    bucket       = "eks-monitor-terraform-bucket"
    key          = "terraform/state"
    region       = "us-east-1"
    use_lockfile = true
  }
}

