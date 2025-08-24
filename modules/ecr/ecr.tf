resource "aws_ecr_repository" "ecr" {
  name = var.repository_name # ім'я репозиторію

  image_tag_mutability = var.image_tag_mutability # або "IMMUTABLE" для незмінних тегів

  force_delete = var.force_delete
  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push # сканування образів при завантаженні
  }
  tags = {
    Name = var.repository_name
  }
}


# ECR Repository Policy
# Доступ лише для акаунтів/ролей із вашого AWS‑тенанта.
data "aws_caller_identity" "current" {}

locals {
  default_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPushPullWithinAccount"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = coalesce(var.repository_policy, local.default_policy)
}
