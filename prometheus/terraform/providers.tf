terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "liorm-4nanox-bucket"
    key    = "tfstate/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  shared_config_files      = [var.aws_config_path]
  shared_credentials_files = [var.aws_cred_path]
  profile                  = "default"

}



