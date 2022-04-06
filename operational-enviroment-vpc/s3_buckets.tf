
resource "aws_s3_bucket" "lambda_bucket" {
  count  = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0
  bucket = var.lambda_buckets[count.index]
}

resource "aws_s3_bucket_policy" "allow_lambda_bucketaccount" {
  count  = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0
  bucket = aws_s3_bucket.lambda_bucket[0].id
  policy = data.aws_iam_policy_document.allow_access_lambda_bucket_account[count.index].json
}


data "aws_iam_policy_document" "allow_access_lambda_bucket_account" {
  count = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0

  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/Role_For-S3_Creation",
      "arn:aws:iam::674293488770:role/Role_For-S3_Creation"]
    }

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.lambda_bucket[0].arn,
      join("/", [aws_s3_bucket.lambda_bucket[0].arn, "*"])
    ]
  }

}
