# bittrader

[![sakamotodesu](https://circleci.com/gh/sakamotodesu/bittrader.svg?style=svg)](https://app.circleci.com/pipelines/github/sakamotodesu/bittrader)


## Build

```bash
./gradlew bootjar

docker build -t sakamotodesu/bittrader .

docker run -p 8080:8080 sakamotodesu/bittrader
```

## Terraform

> Terraform 1.0.11

```bash
# Terraformのバージョンを設定
tfenv use 1.0.11

# AWS SSOで認証
aws sso login --profile <プロファイル名>

# Terraformの初期化と実行
cd tf && terraform init
terraform plan
terraform apply
```

## インフラ構成

- VPC
- ALB (Application Load Balancer)
- ECS Fargate
- Route53
- ACM (SSL証明書)
- S3 (ALBログ用)