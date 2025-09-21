terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "aws" {
  region = var.region
}

# # Підключаємо модуль S3 та DynamoDB
# module "s3_backend" {
#   source         = "./modules/s3-backend" # Шлях до модуля
#   bucket_name    = "preart-goit-bucket"   # Ім'я S3-бакета
#   dynamodb_table = "terraform-locks"      # Ім'я DynamoDB
# }

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block     # CIDR блок для VPC
  public_subnets     = var.public_subnets     # Публічні підмережі
  private_subnets    = var.private_subnets    # Приватні підмережі
  availability_zones = var.availability_zones # Зони доступності
  vpc_name           = var.vpc_name           # Ім'я VPC
}

# Підключаємо модуль Elastic Container Registry
module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name # Ім'я репозиторію
}

# Підключаємо модуль Elastic Kubernetes Service
module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name          # Назва кластера
  subnet_ids    = module.vpc.public_subnets # ID підмереж
  instance_type = var.instance_type         # Тип інстансів
  desired_size  = 2                         # Бажана кількість нодів
  max_size      = 3                         # Максимальна кількість нодів
  min_size      = 1                         # Мінімальна кількість нодів
}
data "aws_eks_cluster" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}
data "aws_eks_cluster_auth" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Підключаємо модуль Jenkins
module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_pat        = var.github_pat
  github_user       = var.github_user
  github_repo_url   = var.github_repo_url
  github_branch     = var.github_branch
  depends_on        = [module.eks]
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

# Підключаємо модуль Argo CD
module "argo_cd" {
  source          = "./modules/argo_cd"
  namespace       = "argocd"
  chart_version   = "5.46.4"
  github_repo_url = var.github_repo_url
  github_pat      = var.github_pat
  github_user     = var.github_user
  github_branch   = var.github_branch
  rds_endpoint    = module.rds.rds_endpoint
  depends_on = [
    module.eks,
    module.ecr,
    module.rds
  ]
}

# Підключаємо модуль Relational Database Service
module "rds" {
  source               = "./modules/rds"
  rds_cluster_name     = var.rds_cluster_name
  use_aurora           = var.use_aurora
  aurora_replica_count = var.aurora_replica_count


  # --- Aurora-only ---
  engine_cluster                = var.engine_cluster
  engine_version_cluster        = var.engine_version_cluster
  parameter_group_family_aurora = var.parameter_group_family_aurora

  # --- RDS-only ---
  engine                     = var.engine
  engine_version             = var.engine_version
  parameter_group_family_rds = var.parameter_group_family_rds

  # --- Common ---
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = var.publicly_accessible
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr_block          = var.vpc_cidr_block
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period

  parameters = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096"
  }

  tags = {
    Environment = var.environment
    Project     = var.project
  }
  
  depends_on = [module.vpc]
}
