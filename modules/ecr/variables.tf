variable "repository_name" {
  description = "Назва репозиторію"
  type        = string
}
variable "image_tag_mutability" {
  description = "MUTABLE або IMMUTABLE для незмінних тегів"
  type        = string
  default     = "MUTABLE"
}

variable "force_delete" {
  description = "Примусово видаляти образи при знищенні бакета"
  type        = bool
  default     = true
}

variable "image_scan_on_push" {
  description = "Сканувати образи на вразливості"
  type        = bool
  default     = true
}

variable "repository_policy" {
  description = "Custom ECR repository policy (optional)"
  type        = string
  default     = null
}
