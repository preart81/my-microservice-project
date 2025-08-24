terraform {
  backend "s3" {
    bucket         = "preart-goit-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
