# Docker

**Завдання**

1. Створити власний проєкт, що включає:

   - Django — для вебзастосунку.
   - PostgreSQL — для збереження даних.
   - Nginx — для обробки запитів.

2. Використати Docker і Docker Compose для контейнеризації всіх сервісів.

3. Запушити проєкт у свій репозиторій на GitHub.

## Виконання завдання

### 1. Створюємо структуру проєкту Django в Docker

Ініціалізуємо новий Django-проєкт django_app.  
Переходимо у директорію django та створюємо проєкт Django

```sh
django-admin startproject django_app .
```

Налаштуйте PostgreSQL як базу даних.
Додайте Nginx для проксирування трафіку.

### 2. Створємо Dockerfile для Django

Dockerfile повинен:

- Використовувати образ Python 3.9 або новіший.
- Встановлювати всі необхідні залежності з requirements.txt.
- Запускати Django-сервер у контейнері.

Створюємо [dockerfile](django/dockerfile)

**Перевірка:**

1. Білдимо образ

   ```sh
   docker build -t django_app .
   ```

2. Запускаємо контейнер

   ```sh
   docker run -d -p 8000:8000 --name django_app django_app
   ```

3. Для перевірки доступності додатку відкриваємо [http://localhost:8000](http://localhost:8000/)

   ![alt text](<md.media/4.1 django.png>)

### 3. Налаштовуємо nginx

Створимо [nginx.conf](nginx/nginx.conf):

- порт nginx: 80
- переадресація: http://web:8000

web - це назва сервісу django-додатку з [docker-compose.yml](docker-compose.yml): Docker Compose створює внутрішню мережу для сервісів, де кожен сервіс доступний за своєю назвою.

### 4. Підготуємо змінні оточення

Заповнимо змінні оточення у файлі [.env](.env) по шаблону з [.env.example](.env.example)

### 5. Створюємо docker-compose.yml

У [docker-compose.yml](docker-compose.yml) опишемо усі три сервіси:

- web — Django-застосунок.
- db — PostgreSQL для збереження даних.
- nginx — вебсервер для обробки запитів.


### 6. Запустимо робочий проект
```sh
docker-compose up -d

...
[+] Running 3/3
 ✔ Container postgres_db  Running     0.0s 
 ✔ Container nginx        Started     2.6s 
 ✔ Container django_app   Started     1.9s 

```

docker-compose up -d --build




### 7. Підготовка додатку до роботи
```sh
# підключаємось до термінала контейнера
docker-compose exec -it web bash

# запускаємо міграції БД
python manage.py migrate

# створюємо користувача
python manage.py createsuperuser

```

При успішному виконанні зможемо залогінитись в адмінку нашого додатку  
http://localhost/admin/login

![django admin](<md.media/4.2 django.png>)


Інтерфейс Site administration
![alt text](<md.media/4.3 django.png>)

