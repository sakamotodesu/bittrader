# bittrader

[![sakamotodesu](https://circleci.com/gh/sakamotodesu/bittrader.svg?style=svg)](https://app.circleci.com/pipelines/github/sakamotodesu/bittrader)


## Build

```bash
./gradlew bootjar

docker build -t sakamotodesu/bittrader .

docker run -p 8080:8080 sakamotodesu/bittrader
```

## Terraform

> Terraform 1.11.2

```bash
# Terraformのバージョンを設定
tfenv use 1.11.2

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

## 概要
Bittraderは、AWS上で動作する暗号資産取引システムです。

## インフラ構成
- ECS Fargate: アプリケーションコンテナの実行環境
- ALB: アプリケーションへのアクセス制御
- S3: ALBログの保存
- VPC: ネットワーク環境

## 前提条件
- AWS CLI v2
- Terraform v1.11.2
- jq

## セットアップ手順

### 1. AWS SSO認証
AWS SSOを使用して認証を行います：

```bash
# AWS SSOログインスクリプトを使用する場合
source scripts/aws-sso-login.sh -p <プロファイル名>

# 例：
source scripts/aws-sso-login.sh -p AdministratorAccess-616703994274
```

このスクリプトは以下の処理を行います：
1. AWS SSOでログイン
2. 認証情報の取得と確認
3. 環境変数への認証情報の設定
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_SESSION_TOKEN

### 2. Terraformの初期化と実行
```bash
cd tf
terraform init
terraform plan
terraform apply
```

## インフラ構成の詳細
- VPC: 10.0.0.0/16
- パブリックサブネット: 10.0.1.0/24, 10.0.2.0/24
- プライベートサブネット: 10.0.3.0/24, 10.0.4.0/24
- ALB: パブリックサブネットに配置
- ECS: プライベートサブネットに配置
- S3: ALBログの保存（180日で自動削除）

## 注意事項
- AWS SSOの認証情報は一時的なものなので、定期的に再認証が必要です
- 認証情報の有効期限は12時間です
- 認証情報は環境変数として設定されるため、新しいターミナルセッションでは再度認証が必要です