resource "aws_vpc" "bittrader-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "bittrader"
  }
}

resource "aws_subnet" "bittrader-subnet-private_0" {
  vpc_id = aws_vpc.bittrader-vpc.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "bittrader-subnet-private_1" {
  vpc_id = aws_vpc.bittrader-vpc.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "bittrader-subnet-public_0" {
  vpc_id = aws_vpc.bittrader-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "bittrader-subnet-public_1" {
  vpc_id = aws_vpc.bittrader-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "bittrader-igw" {
  vpc_id = aws_vpc.bittrader-vpc.id
}

resource "aws_route_table" "bittrader-route-table" {
  vpc_id = aws_vpc.bittrader-vpc.id
}

resource "aws_route" "bittrader-route" {
  route_table_id = aws_route_table.bittrader-route-table.id
  gateway_id = aws_internet_gateway.bittrader-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_0" {
  subnet_id = aws_subnet.bittrader-subnet-public_0.id
  route_table_id = aws_route_table.bittrader-route-table.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.bittrader-subnet-public_1.id
  route_table_id = aws_route_table.bittrader-route-table.id
}


module "bittrader-vpc-sg" {
  source = "./security_group"
  name = "bittrader-vpc-sg"
  vpc_id = aws_vpc.bittrader-vpc.id
  port = 80
  cidr_blocks = [
    "0.0.0.0/0"]
}


resource "aws_lb" "bittrader-alb" {
  name = "bittrader-alb"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  enable_deletion_protection = true

  subnets = [
    aws_subnet.bittrader-subnet-public_0.id,
    aws_subnet.bittrader-subnet-public_1.id,
  ]

  access_logs {
    bucket = aws_s3_bucket.bittrader-alb-log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

module "http_sg" {
  source = "./security_group"
  name = "http-sg"
  vpc_id = aws_vpc.bittrader-vpc.id
  port = 80
  cidr_blocks = [
    "0.0.0.0/0"]
}

module "https_sg" {
  source = "./security_group"
  name = "https-sg"
  vpc_id = aws_vpc.bittrader-vpc.id
  port = 443
  cidr_blocks = [
    "0.0.0.0/0"]
}

module "http_redirect_sg" {
  source = "./security_group"
  name = "http-redirect-sg"
  vpc_id = aws_vpc.bittrader-vpc.id
  port = 8080
  cidr_blocks = [
    "0.0.0.0/0"]
}

output "alb_dns_name" {
  value = aws_lb.bittrader-alb.name
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.bittrader-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code = "200"
    }
  }
}