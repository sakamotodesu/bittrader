# bittrader

[![sakamotodesu](https://circleci.com/gh/sakamotodesu/bittrader.svg?style=svg)](https://app.circleci.com/pipelines/github/sakamotodesu/bittrader)

./gradlew bootjar

docker build -t sakamotodesu/bittrader .

docker run -p 8080:8080 sakamotodesu/bittrader