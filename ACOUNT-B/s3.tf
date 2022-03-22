resource "aws_s3_bucket" "test_bucket" {
  count  = length(var.bucket)
  bucket = var.bucket[count.index]
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count  = length(var.bucket)
  bucket = aws_s3_bucket.test_bucket[0].id
  policy = data.aws_iam_policy_document.allow_access_from_another_accountA.json
}

data "aws_iam_policy_document" "allow_access_from_another_accountA" {

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/Role_For-S3_Creation", "arn:aws:iam::674293488770:role/Role_For-S3_Creation"]
    } # arn:aws:iam::674293488770:role/Role_For-S3_Creation

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.test_bucket[0].arn,
      join("/", [aws_s3_bucket.test_bucket[0].arn, "*"])
    ]
  }

}
