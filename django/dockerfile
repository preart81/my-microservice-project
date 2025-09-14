# 2. Створимо Dockerfile для Django

# Наш Dockerfile повинен:
# - Використовувати образ Python 3.9 або новіший.
# - Встановлювати всі необхідні залежності з requirements.txt.
# - Запускати Django-сервер у контейнері.

FROM python:3.10-slim
# Встановлюємо робочий каталог
WORKDIR /app
# Копіюємо список залежностей
COPY requirements.txt .
# Встановлюємо залежності
RUN pip install --no-cache-dir -r requirements.txt
# Налаштовуємо змінні середовища
ENV POSTGRES_HOST=${POSTGRES_HOST}
ENV POSTGRES_PORT=${POSTGRES_PORT}
ENV POSTGRES_NAME=${POSTGRES_NAME}
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
# Копіюємо файли проекту
COPY . .
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
