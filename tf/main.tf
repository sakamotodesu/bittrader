terraform {
  backend "s3" {
    bucket = "sakamotodesu-bittrader-tfstate"
    key = "terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_version = "= 0.12.23"
}

provider "aws" {
  version = "= 2.52.0"
}

resource "aws_ecr_repository" "bittrader" {
  name = "bittrader"
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

resource "aws_ecs_cluster" "bittrader-cluster" {
  name = "bittrader-cluster"
}

resource "aws_ecs_service" "bittrader-service" {
  name = "bittrader-service"
  cluster = aws_ecs_cluster.bittrader-cluster.id
  task_definition = aws_ecs_task_definition.bittrader-service.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    assign_public_ip = true
    security_groups = [
      "sg-0577bab4e1fc38cbf"]
    subnets = [
      "subnet-02902f75"
    ]
  }

  lifecycle {
    ignore_changes = [
      task_definition]
  }
}

resource "aws_ecs_task_definition" "bittrader-service" {
  family = "bittrader-service"
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  execution_role_arn = "arn:aws:iam::616703994274:role/ecsTaskExecutionRole"
  requires_compatibilities = [
    "FARGATE"]
  container_definitions = file("task-definitions/bittrader-service.json")
}