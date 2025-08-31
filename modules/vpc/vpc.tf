# Створюємо основну VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block # CIDR блок для нашої VPC (наприклад, 10.0.0.0/16)
  enable_dns_support   = true               # Вмикає підтримку DNS у VPC
  enable_dns_hostnames = true               # Вмикає можливість використання DNS-імен для ресурсів у VPC

  tags = {
    Name = "${var.vpc_name}-vpc" 
  }
}

# Створюємо публічні підмережі
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets) 
  vpc_id                  = aws_vpc.main.id 
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}" 
    # Тег з нумерацією підмережі
    # count.index — це індекс циклу "count", який починається з 0.
    # ${count.index + 1} додає +1 до індексу, щоб отримати людське позначення (1, 2, 3 замість 0, 1, 2).
  }
}

# Створюємо приватні підмережі
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id 
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

# Створюємо Internet Gateway для публічних підмереж
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Створюємо Elastic IP для NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# Створюємо NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # Розміщуємо NAT в першій публічній підмережі
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

