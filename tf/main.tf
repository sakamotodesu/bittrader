terraform {
  backend "s3" {
    bucket = "sakamotodesu-bittrader-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_version = "= 0.12.23"
}

provider "aws" {
  version = "= 2.52.0"
}