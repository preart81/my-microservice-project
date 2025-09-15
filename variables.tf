variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster-devops"
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-devops"
}
variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
  default     = "t3.medium"
}
variable "repository_name" {
  description = "Name of the ECR repository (унікальна в акаунті та регіоні)."
  type        = string
  default     = "ecr-repo-preart-18062025214500"
}
// github credentials
variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
}
variable "github_user" {
  description = "GitHub username"
  type        = string
}
variable "github_repo_url" {
  description = "GitHub repository name"
  type        = string
}
variable "github_branch" {
  description = "GitHub branch name"
  type        = string
  default     = "lesson-8-9"
}
