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
    assign_public_ip = false
    security_groups = [
      module.bittrader-ecs-sg.security_group_id]

    subnets = [
      aws_subnet.bittrader-subnet-private_0.id,
      aws_subnet.bittrader-subnet-private_1.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.bittrader-alb-target.arn
    container_name = "bittrader-service"
    container_port = 8080
  }


  lifecycle {
    ignore_changes = [
      task_definition]
  }
}

module "bittrader-ecs-sg" {
  source = "./security_group"
  name = "bittrader-ecs-sg"
  vpc_id = aws_vpc.bittrader-vpc.id
  port = 80
  cidr_blocks = [
    aws_vpc.bittrader-vpc.cidr_block]
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