# bittrader

[![sakamotodesu](https://circleci.com/gh/sakamotodesu/bittrader.svg?style=svg)](https://app.circleci.com/pipelines/github/sakamotodesu/bittrader)

./gradlew bootjar

docker build -t sakamotodesu/bittrader .

docker run -p 80:80 sakamotodesu/bittrader