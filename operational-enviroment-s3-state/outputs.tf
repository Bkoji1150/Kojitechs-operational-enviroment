# For loop with splat operation
output "bucket__state_name" {
  description = "List all buckets"
  value       = [for buckets in aws_s3_bucket.test_bucket : buckets.bucket]
}

# for loop with Map

output "for_loop_map" {
  description = "List all buckets"
  value       = { for buckets in aws_s3_bucket.test_bucket : buckets.id => buckets.bucket_domain_name }
}

# Output - For Loop with Map Advanced
output "for_output_map2" {
  description = "For Loop with Map - Advanced"
  value       = { for c, buckets in aws_s3_bucket.test_bucket : c => buckets.bucket }
}

# Output Latest Generalized Splat Operator - Returns the List
output "latest_splat_instance_publicdns" {
  description = "Generalized latest Splat Operator"
  value       = aws_s3_bucket.test_bucket[*].bucket
}

output "zdynamodb_name" {
  description = "Usae this dynamodb table"
  value       = aws_dynamodb_table.dynamodb-terraform-lock.name
}
