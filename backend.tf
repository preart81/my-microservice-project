# Закоментувати бекенд S3 для першого запуску
terraform {
  backend "s3" {
    bucket         = "preart-goit-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# # Явно вказаний локальний бекенд для першого запуску
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
