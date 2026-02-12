# Базовый образ — официальный легковесный веб-сервер nginx
FROM nginx:alpine

# Информация о создателе
LABEL maintainer="student@example.com"

# Копируем нашу HTML-страницу внутрь контейнера
# В nginx стандартная директория для статики - /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/index.html

# Указываем порт, который будет использовать контейнер
EXPOSE 80

# Nginx запускается автоматически, отдельно указывать CMD не нужно