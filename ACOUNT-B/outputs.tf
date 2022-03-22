
output "bucket__state_name" {
  value = [for buckets in aws_s3_bucket.test_bucket : buckets.bucket]
}
