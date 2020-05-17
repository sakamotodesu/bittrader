resource "aws_s3_bucket" "bittrader-alb-log" {
  bucket = "sakamotodesu-bittrader-alb-log"
  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "bittrader-alb-log-policy" {
  bucket = aws_s3_bucket.bittrader-alb-log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bittrader-alb-log.id}/*"]

    principals {
      type = "AWS"
      identifiers = [
        "582318560864"]
    }
  }
}