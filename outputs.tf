output "s3_bucket_name" {
  description = "Назва S3-бакета"
  value       = module.s3_backend.s3_bucket_name
}

output "s3_bucket_url" {
  description = "URL S3-бакета"
  value       = module.s3_backend.s3_bucket_url
}

output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Приватні підмережі"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Публічні підмережі"
  value       = module.vpc.public_subnets
}

output "ecr_repository_url" {
  description = "Повний URL репозиторію"
  value       = module.ecr.ecr_repository_url
}

