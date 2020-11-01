terraform {
  backend "s3" {
    bucket = "sakamotodesu-bittrader-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}