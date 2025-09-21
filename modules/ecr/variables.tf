# Required
variable "repository_name" {
  description = "Назва ECR репозиторію (унікальна в акаунті та регіоні)."
  type        = string
}
# Optional
variable "scan_on_push" {
  type        = bool
  description = "Чи сканувати образи на вразливості одразу після push."
  default     = true
}
variable "image_tag_mutability" {
  description = "IMMUTABLE заблокує зміну існуючих тегів; MUTABLE дозволяє перезапис."
  type        = string
  default     = "MUTABLE"
}
variable "force_delete" {
  description = "Якщо true, видалення репо автоматично видаляє всі образи всередині."
  type        = bool
  default     = true
}
variable "repository_policy" {
  description = "JSON-політика репозиторію."
  type        = string
  default     = null
}