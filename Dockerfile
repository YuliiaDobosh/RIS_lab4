# Вказуємо базовий образ з Node.js (версію можна змінити при необхідності)
FROM node:20

# Встановлюємо робочу директорію в контейнері
WORKDIR /app

# Копіюємо package.json та package-lock.json (якщо є) для інсталяції залежностей
COPY package*.json ./

# Встановлюємо залежності
RUN npm install

# Копіюємо всі файли проєкту в контейнер
COPY . .

# Компілюємо додаток для production
RUN npm run build

# Використовуємо Nginx для сервування статичних файлів
FROM nginx:stable-alpine

# Копіюємо згенеровані статичні файли з попереднього контейнера до папки Nginx
COPY --from=0 /app/dist /usr/share/nginx/html

# Копіюємо налаштування Nginx (необов'язково, якщо потрібно змінити налаштування)
COPY nginx.conf /etc/nginx/nginx.conf

# Відкриваємо порт 80 для доступу до сервера
EXPOSE 80

# Запускаємо Nginx
CMD ["nginx", "-g", "daemon off;"]