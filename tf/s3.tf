resource "aws_s3_bucket" "bittrader-alb-log" {
  bucket = "sakamotodesu-${var.service_name}-alb-log"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "Service" = var.service_name
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bittrader-alb-log" {
  bucket = aws_s3_bucket.bittrader-alb-log.id
  rule {
    id     = "expire_after_180_days"
    status = "Enabled"
    expiration {
      days = 180
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