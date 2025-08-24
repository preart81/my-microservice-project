
variable "vpc_cidr_block" {
  description = ""
  type = string
}

variable "vpc_name" {
  description = ""
  type = string
}



variable "availability_zones" {
  description = "Список зон доступності для підмереж"
  type = list(string)
}

# Створюємо кілька підмереж, кількість визначена довжиною списку public_subnets
variable "public_subnets" {
  description = "CIDR для публічних підмереж"
  type = list(string)
}

# Створюємо кілька приватних підмереж, кількість відповідає довжині списку private_subnets
variable "private_subnets" {
  description = "CIDR для приватних підмереж"
  type = list(string)
}
