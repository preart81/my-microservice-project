variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "namespace" {
  description = "Kubernetes namespace for deploying Jenkins"
  type        = string
  default     = "jenkins"
}
variable "oidc_provider_arn" {
  description = "OIDC provider ARN from EKS cluster"
  type        = string
}
variable "oidc_provider_url" {
  description = "OIDC provider URL from EKS cluster"
  type        = string
}
// github credentials
variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
variable "github_user" {
  description = "GitHub username"
  type        = string
}
variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}
variable "github_branch" {
  description = "GitHub branch name"
  type        = string
  default     = "final-project"
}
