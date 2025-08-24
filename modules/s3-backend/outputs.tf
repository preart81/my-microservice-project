output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_url" {
  description = "URL of the created S3 bucket"
  value       = "https://${aws_s3_bucket.terraform_state.bucket_regional_domain_name}"
}

output "dynamodb_table_name" {
  description = "DynamoDB table name - назва таблиця для блокування стейтів"
  value       = aws_dynamodb_table.terraform_locks.name
}
