terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "ahsan-tfstate-702607806360"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

output "hello" {
  value = "remote state works"
}

module "vpc" {
  source     = "./modules/vpc"
  name       = "platform-dev"
  cidr_block = "10.0.0.0/16"
}
