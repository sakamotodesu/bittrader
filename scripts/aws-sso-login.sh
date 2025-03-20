#!/bin/bash

# 使用方法を表示する関数
usage() {
    echo "Usage: source $0 -p <profile-name>"
    echo "  -p: AWS SSOプロファイル名（必須）"
    echo "  -h: このヘルプメッセージを表示"
    return 1
}

# プロファイル名の初期化
PROFILE=""

# 引数の処理
if [ $# -eq 0 ]; then
    usage
    return 1
fi

# 引数の解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -p)
            PROFILE="$2"
            shift 2
            ;;
        -h)
            usage
            return 0
            ;;
        *)
            echo "Error: 不明なオプション: $1"
            usage
            return 1
            ;;
    esac
done

# プロファイル名が指定されていない場合はエラー
if [ -z "$PROFILE" ]; then
    echo "Error: プロファイル名を指定してください"
    usage
    return 1
fi

# AWS SSOの認証情報を取得
echo "AWS SSO認証情報を取得中..."
aws sso login --profile "$PROFILE"

# 認証情報の取得に失敗した場合はエラー
if [ $? -ne 0 ]; then
    echo "Error: AWS SSO認証に失敗しました"
    return 1
fi

# 認証情報の確認と取得
echo "認証情報を確認中..."
aws sts get-caller-identity --profile "$PROFILE"

# 認証情報の取得に失敗した場合はエラー
if [ $? -ne 0 ]; then
    echo "Error: 認証情報の取得に失敗しました"
    return 1
fi

# 認証情報のキャッシュを読み込む
CACHE_DIR="$HOME/.aws/cli/cache"
LATEST_CACHE=$(ls -t "$CACHE_DIR"/*.json 2>/dev/null | head -n1)

if [ -z "$LATEST_CACHE" ]; then
    echo "Error: 認証情報のキャッシュが見つかりません"
    return 1
fi

# 認証情報を環境変数に設定
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' "$LATEST_CACHE")
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' "$LATEST_CACHE")
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' "$LATEST_CACHE")

# 認証情報が正しく設定されたか確認
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_SESSION_TOKEN" ]; then
    echo "Error: 認証情報の設定に失敗しました"
    return 1
fi

# 認証情報の確認
echo "認証情報の設定が完了しました"
aws sts get-caller-identity 