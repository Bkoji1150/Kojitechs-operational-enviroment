resource "aws_s3_bucket" "test_bucket" {
  bucket = "allowec2buckectfordifferentaccount"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_accountA.json
}

data "aws_iam_policy_document" "allow_access_from_another_accountA" {

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/ec2-s3"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.test_bucket.arn,
      "${aws_s3_bucket.test_bucket.arn}/*",
    ]
  }
}
