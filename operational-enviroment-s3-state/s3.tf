
resource "aws_s3_bucket" "test_bucket" {
  count  = length(var.bucket)
  bucket = element(var.bucket, count.index)

  lifecycle {
    prevent_destroy = true
  }

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
      type = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/Role_For-S3_Creation",
      "arn:aws:iam::674293488770:role/Role_For-S3_Creation", "arn:aws:iam::181437319056:role/Role_For-S3_Creation", ]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.test_bucket[0].arn,
      join("/", [aws_s3_bucket.test_bucket[0].arn, "*"])
    ]
  }
}


resource "aws_iam_policy" "terraform-statelock" {
  name   = "${var.component_name}-terraform-statelock"
  policy = data.aws_iam_policy_document.allow_access_to_dynamo_from_another_accountA.json
}

resource "aws_iam_role" "my_dynamodb_appautoscaling" {
  name               = "my_dynamodb_appautoscaling"
  assume_role_policy = data.aws_iam_policy_document.appautoscaling_assume_role_policy.json
}

data "aws_iam_policy_document" "appautoscaling_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/Role_For-S3_Creation",
      "arn:aws:iam::674293488770:role/Role_For-S3_Creation", "arn:aws:iam::181437319056:role/Role_For-S3_Creation"]
    }
  }
}
data "aws_iam_policy_document" "allow_access_to_dynamo_from_another_accountA" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = [
      aws_dynamodb_table.dynamodb-terraform-lock.arn
    ]
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
