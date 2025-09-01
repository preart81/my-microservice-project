variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}
variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}
variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}
variable "github_repo_url" {
  description = "GitHub repository URL for ArgoCD applications"
  type        = string
}
variable "github_user" {
  description = "GitHub user for ArgoCD applications"
  type        = string
}
variable "github_pat" {
  description = "GitHub personal access token for ArgoCD applications"
  type        = string
}
