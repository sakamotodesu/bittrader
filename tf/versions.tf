terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = "= 0.13.5"
}

provider "aws" {
  version = "= 2.52.0"
  region  = "ap-northeast-1"
}