# Repository Guidelines

## プロジェクト構成とモジュール配置
- `src/main/java/com/sakamotodesu/bittrader/`: Spring Bootアプリ本体（エントリポイントは`App`）。
- `src/main/resources/`: 実行時設定（例: `application.properties`）。
- `src/test/java/com/sakamotodesu/bittrader/`: JUnit 5のテスト（例: `AppTest`）。
- `tf/`: AWS向けTerraform定義。
- `scripts/`: 補助スクリプト（例: AWS SSOログイン）。
- `Dockerfile`: コンテナビルド定義。

## ビルド・テスト・開発コマンド
- `./gradlew bootJar`: 実行可能なSpring Boot JARを作成。
- `./gradlew bootRun`: ローカル起動（既定は8080）。
- `./gradlew test`: JUnit 5のユニットテスト実行。
- `docker build -t bittrader .` / `docker run -p 8080:8080 bittrader`: コンテナのビルドと起動。
- `cd tf && terraform init && terraform plan`: Terraform初期化と差分確認（Terraform 1.11.2）。

## コーディング規約・命名
- Java 17、インデントは4スペース、Spring Boot標準に準拠。
- パッケージ名は`com.sakamotodesu.bittrader`配下。
- クラスは`PascalCase`、メソッド・変数は`camelCase`。
- 設定は`application.properties`に集約し、秘密情報は直書きしない。

## テスト指針
- フレームワークは`spring-boot-starter-test`（JUnit 5）。
- テストクラスは`*Test`で終わる名前にする。
- 追加ロジックはユニットテストでカバーし、決定的・最小限に保つ。

## コミットとPRのガイド
- コミットメッセージは慣例形式（例: `chore: ...`, `chore(deps): ...`）。日本語も可。
- PRには概要、実行したテスト（例: `./gradlew test`）、関連Issueを記載する。
- `tf/`変更は`terraform plan`の結果か要約を添付する。

## セキュリティと設定の注意
- AWS作業はSSO前提。`scripts/aws-sso-login.sh`を参照し、認証情報はコミットしない。
- アプリの既定ポートは8080。必要に応じてSpring Boot設定で上書きする。
