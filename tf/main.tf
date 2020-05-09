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

resource "aws_ecr_repository" "bittrader" {
  name                 = "bittrader"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "bittrader-policy" {
  repository = aws_ecr_repository.bittrader.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "circleci_allow",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}