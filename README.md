# IaC (Terraform)

Опис завдання

Завдання полягає у створенні Terraform-структури для інфраструктури на AWS.

Потрібно налаштувати:

1. Синхронізацію стейт-файлів у S3 з використанням DynamoDB для блокування.
2. Мережеву інфраструктуру (VPC) з публічними та приватними підмережами.
3. ECR (Elastic Container Registry) для зберігання Docker-образів.

Структура проекту

```sh
lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проєкту

```

Команди для ініціалізації та запуску:

```sh
# Ініціалізація робочого каталогу Terraform (створення файлу terraform.tfstate)
terraform init

# Огляд змін (планування) до інфраструктури
terraform plan

# Застосування змін до інфраструктури
terraform apply

# Видалення інфраструктури
terraform destroy
```

## Опис модулів

- [vpc](modules/vpc) - модуль для створення VPC, підмереж, Internet Gateway
- [ecr](modules/ecr) - модуль для створення ECR репозиторію
- [s3](modules/s3-backend) - модуль для створення S3-бакету та DynamoDB для зберігання стейтів

Для додаткової інформації див. коментарі всередині модулів.

## Налаштування доступів

Критичні дані заповнюємо в [terraform.tfvars](terraform.tfvars) і додаємо файл в [.gitignore](.gitignore)

```tfvars
# terraform.tfvars

# ---------------- github ----------------

# облікові дані для доступу до приватного репозиторію
github_user = "YOUR_USERNAME"

# токен доступу
github_pat = "ghp_token"

# повна URL-адреса Git-репозиторію https://github.com/YOUR_USERNAME/example-repo.git
github_repo_url = "https://github.com/YOUR_USERNAME/example-repo.git"
```

## Перший запуск

Перед першим запуском може виникнути помилка збереження стейта, оскільки ще не створено DynamoDB та bucket. Для уникнення помилки потрібно виконати перший запуск наступним чином:

1. S3-бакет з іменем, налаштованим у параметрі `bucket_name` [main.tf](main.tf) повинен бути створений
   ([Terraform / Configuration Language / Backend block /
   s3](https://developer.hashicorp.com/terraform/language/backend/s3))
2. Закоментуємо конфігурацію бекенда "s3" у файлі [backend.tf](backend.tf).
   Це змусить Terraform тимчасово використовувати локальний файл стану.
3. Потім запускаємо `terraform init` і `terraform apply`, щоб створити S3 bucket і таблицю DynamoDB в AWS.
4. Після того, як ресурси будуть створені, розкоментуємо конфігурацію бекенда "s3" у [backend.tf](backend.tf).
5. Нарешті, знову запускаємо `terraform init`. Terraform виявить існуючий локальний стан і попросить перенести його до новоствореного бекенду S3.
