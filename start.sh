#!/bin/bash

# =============================================
#   Docker Simple App - Управляющий скрипт
#   Полный набор команд для работы с Docker
# =============================================

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Конфигурация
PROJECT_NAME="docker-simple-app"
IMAGE_NAME="my-nginx-app"
CONTAINER_NAME="web-server"
DOCKER_COMPOSE_FILE="docker-compose.yml"
PORT=8080

# Создание необходимых директорий
mkdir -p logs data

# Функция для вывода заголовков
print_header() {
    echo -e "\n${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}   $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}\n"
}

# Функция для вывода успеха
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Функция для вывода информации
print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

# Функция для вывода предупреждения
print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Функция для вывода ошибки
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# =============================================
#   1. КОМАНДЫ ДЛЯ РАБОТЫ С ОБРАЗАМИ
# =============================================

# Поиск образов на Docker Hub
search_images() {
    print_header "ПОИСК ОБРАЗОВ НА DOCKER HUB"
    echo "Ищем образ nginx..."
    docker search nginx | head -n 10
}

# Загрузка образа
pull_image() {
    print_header "ЗАГРУЗКА ОБРАЗА"
    echo "Загружаем образ nginx:alpine..."
    docker pull nginx:alpine
    print_success "Образ загружен"
}

# Просмотр всех образов
list_images() {
    print_header "СПИСОК ОБРАЗОВ"
    docker images
}

# Сборка собственного образа
build_image() {
    print_header "СБОРКА ОБРАЗА"
    echo "Собираем образ $IMAGE_NAME..."
    docker build -t $IMAGE_NAME .
    if [ $? -eq 0 ]; then
        print_success "Образ $IMAGE_NAME успешно собран"
    else
        print_error "Ошибка сборки образа"
    fi
}

# Сборка с указанием версии
build_image_with_tag() {
    print_header "СБОРКА ОБРАЗА С ТЕГОМ"
    read -p "Введите тег (например: v1.0): " tag
    docker build -t $IMAGE_NAME:$tag .
    print_success "Образ $IMAGE_NAME:$tag собран"
}

# Удаление образа
remove_image() {
    print_header "УДАЛЕНИЕ ОБРАЗА"
    docker images | grep $IMAGE_NAME
    read -p "Введите ID образа для удаления: " image_id
    docker rmi $image_id
    print_success "Образ удален"
}

# Удаление всех неиспользуемых образов
prune_images() {
    print_header "ОЧИСТКА НЕИСПОЛЬЗУЕМЫХ ОБРАЗОВ"
    docker image prune -a -f
    print_success "Неиспользуемые образы удалены"
}

# =============================================
#   2. КОМАНДЫ ДЛЯ РАБОТЫ С КОНТЕЙНЕРАМИ
# =============================================

# Запуск контейнера
run_container() {
    print_header "ЗАПУСК КОНТЕЙНЕРА"
    echo "Запускаем контейнер $CONTAINER_NAME на порту $PORT..."
    docker run -d \
        --name $CONTAINER_NAME \
        -p $PORT:80 \
        -v $(pwd)/index.html:/usr/share/nginx/html/index.html \
        --restart unless-stopped \
        $IMAGE_NAME
    
    if [ $? -eq 0 ]; then
        print_success "Контейнер $CONTAINER_NAME запущен"
        print_info "Откройте браузер: http://localhost:$PORT"
    else
        print_error "Ошибка запуска контейнера"
    fi
}

# Запуск с интерактивной оболочкой
run_interactive() {
    print_header "ЗАПУСК С ИНТЕРАКТИВНОЙ ОБОЛОЧКОЙ"
    docker run -it --rm \
        -p $PORT:80 \
        -v $(pwd)/index.html:/usr/share/nginx/html/index.html \
        $IMAGE_NAME sh
}

# Просмотр запущенных контейнеров
list_containers() {
    print_header "ЗАПУЩЕННЫЕ КОНТЕЙНЕРЫ"
    docker ps
}

# Просмотр всех контейнеров
list_all_containers() {
    print_header "ВСЕ КОНТЕЙНЕРЫ"
    docker ps -a
}

# Остановка контейнера
stop_container() {
    print_header "ОСТАНОВКА КОНТЕЙНЕРА"
    docker stop $CONTAINER_NAME
    print_success "Контейнер $CONTAINER_NAME остановлен"
}

# Запуск остановленного контейнера
start_container() {
    print_header "ЗАПУСК ОСТАНОВЛЕННОГО КОНТЕЙНЕРА"
    docker start $CONTAINER_NAME
    print_success "Контейнер $CONTAINER_NAME запущен"
}

# Перезапуск контейнера
restart_container() {
    print_header "ПЕРЕЗАПУСК КОНТЕЙНЕРА"
    docker restart $CONTAINER_NAME
    print_success "Контейнер $CONTAINER_NAME перезапущен"
}

# Удаление контейнера
remove_container() {
    print_header "УДАЛЕНИЕ КОНТЕЙНЕРА"
    docker stop $CONTAINER_NAME 2>/dev/null
    docker rm $CONTAINER_NAME
    print_success "Контейнер $CONTAINER_NAME удален"
}

# Удаление всех остановленных контейнеров
remove_all_stopped() {
    print_header "УДАЛЕНИЕ ВСЕХ ОСТАНОВЛЕННЫХ КОНТЕЙНЕРОВ"
    docker container prune -f
    print_success "Остановленные контейнеры удалены"
}

# =============================================
#   3. КОМАНДЫ ДЛЯ РАБОТЫ ВНУТРИ КОНТЕЙНЕРА
# =============================================

# Вход в контейнер
exec_container() {
    print_header "ВХОД В КОНТЕЙНЕР"
    echo "Входим в контейнер $CONTAINER_NAME..."
    docker exec -it $CONTAINER_NAME sh
}

# Просмотр логов
show_logs() {
    print_header "ЛОГИ КОНТЕЙНЕРА"
    docker logs $CONTAINER_NAME | tail -n 50
}

# Просмотр логов в реальном времени
follow_logs() {
    print_header "ЛОГИ В РЕАЛЬНОМ ВРЕМЕНИ (Ctrl+C для выхода)"
    docker logs -f $CONTAINER_NAME
}

# Статистика использования ресурсов
show_stats() {
    print_header "СТАТИСТИКА ИСПОЛЬЗОВАНИЯ РЕСУРСОВ"
    docker stats --no-stream
    echo ""
    print_info "Для просмотра в реальном времени используйте: docker stats"
}

# Просмотр процессов в контейнере
show_processes() {
    print_header "ПРОЦЕССЫ В КОНТЕЙНЕРЕ"
    docker top $CONTAINER_NAME
}

# =============================================
#   4. КОМАНДЫ ДЛЯ РАБОТЫ С ТОМАМИ
# =============================================

# Создание тома
create_volume() {
    print_header "СОЗДАНИЕ ТОМА"
    local volume_name="${PROJECT_NAME}_data"
    docker volume create $volume_name
    print_success "Том $volume_name создан"
}

# Просмотр томов
list_volumes() {
    print_header "СПИСОК ТОМОВ"
    docker volume ls
}

# Удаление тома
remove_volume() {
    print_header "УДАЛЕНИЕ ТОМА"
    docker volume ls
    read -p "Введите имя тома для удаления: " volume_name
    docker volume rm $volume_name
    print_success "Том удален"
}

# Очистка неиспользуемых томов
prune_volumes() {
    print_header "ОЧИСТКА НЕИСПОЛЬЗУЕМЫХ ТОМОВ"
    docker volume prune -f
    print_success "Неиспользуемые тома удалены"
}

# =============================================
#   5. КОМАНДЫ DOCKER COMPOSE
# =============================================

# Запуск через compose
compose_up() {
    print_header "ЗАПУСК ЧЕРЕЗ DOCKER COMPOSE"
    docker-compose up -d
    print_success "Проект запущен через Docker Compose"
}

# Сборка и запуск compose
compose_up_build() {
    print_header "СБОРКА И ЗАПУСК COMPOSE"
    docker-compose up -d --build
    print_success "Проект собран и запущен"
}

# Остановка compose
compose_down() {
    print_header "ОСТАНОВКА COMPOSE"
    docker-compose down
    print_success "Проект остановлен"
}

# Остановка compose с удалением томов
compose_down_volumes() {
    print_header "ОСТАНОВКА COMPOSE С УДАЛЕНИЕМ ТОМОВ"
    docker-compose down -v
    print_success "Проект остановлен, тома удалены"
}

# Просмотр compose контейнеров
compose_ps() {
    print_header "COMPOSE КОНТЕЙНЕРЫ"
    docker-compose ps
}

# Просмотр compose логов
compose_logs() {
    print_header "COMPOSE ЛОГИ"
    docker-compose logs --tail=50
}

# Следование за compose логами
compose_logs_follow() {
    print_header "COMPOSE ЛОГИ В РЕАЛЬНОМ ВРЕМЕНИ"
    docker-compose logs -f
}

# =============================================
#   6. ДИАГНОСТИКА И ИНФОРМАЦИЯ
# =============================================

# Проверка статуса
check_status() {
    print_header "СТАТУС ПРОЕКТА"
    
    echo -e "${CYAN}Образы:${NC}"
    docker images | head -n 3
    
    echo -e "\n${CYAN}Контейнеры:${NC}"
    docker ps -a | grep -E "(CONTAINER|$CONTAINER_NAME|web-server)"
    
    echo -e "\n${CYAN}Тома:${NC}"
    docker volume ls | head -n 3
    
    echo -e "\n${CYAN}Использование диска:${NC}"
    docker system df
}

# Очистка системы
cleanup() {
    print_header "ПОЛНАЯ ОЧИСТКА СИСТЕМЫ"
    print_warning "Это удалит все остановленные контейнеры, неиспользуемые сети, образы и тома!"
    read -p "Продолжить? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker system prune -a -f --volumes
        print_success "Система очищена"
    else
        print_info "Операция отменена"
    fi
}

# Информация о Docker
docker_info() {
    print_header "ИНФОРМАЦИЯ О DOCKER"
    docker info | grep -E "Server Version|Storage Driver|Logging Driver|Cgroup Driver|Kernel Version|Operating System|OSType|Architecture|CPUs|Total Memory|Docker Root Dir"
}

# Тестирование приложения
test_app() {
    print_header "ТЕСТИРОВАНИЕ ПРИЛОЖЕНИЯ"
    
    # Проверка доступности приложения
    echo "Проверка http://localhost:$PORT..."
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT | grep -q "200"; then
        print_success "Приложение доступно (HTTP 200)"
        
        # Загружаем заголовки
        echo -e "\n${CYAN}Заголовки ответа:${NC}"
        curl -I http://localhost:$PORT 2>/dev/null | head -n 10
    else
        print_error "Приложение недоступно"
    fi
}

# =============================================
#   7. БЫСТРЫЕ КОМАНДЫ (ШОРТКАДЫ)
# =============================================

# Быстрый старт - полный цикл
quick_start() {
    print_header "БЫСТРЫЙ СТАРТ ПРОЕКТА"
    
    # Проверяем наличие Dockerfile
    if [ ! -f "Dockerfile" ]; then
        print_error "Dockerfile не найден!"
        exit 1
    fi
    
    # 1. Загружаем базовый образ
    print_info "1. Загружаем базовый образ..."
    docker pull nginx:alpine
    
    # 2. Собираем образ
    print_info "2. Собираем образ..."
    docker build -t $IMAGE_NAME .
    
    # 3. Удаляем старый контейнер если есть
    docker stop $CONTAINER_NAME 2>/dev/null
    docker rm $CONTAINER_NAME 2>/dev/null
    
    # 4. Запускаем контейнер
    print_info "3. Запускаем контейнер..."
    docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME
    
    # 5. Проверяем статус
    print_info "4. Проверяем статус..."
    sleep 2
    if docker ps | grep -q $CONTAINER_NAME; then
        print_success "✅ Проект успешно запущен!"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}📌 Приложение доступно по адресу: http://localhost:$PORT${NC}"
        echo -e "${CYAN}📌 Имя контейнера: $CONTAINER_NAME${NC}"
        echo -e "${CYAN}📌 Имя образа: $IMAGE_NAME${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        print_error "❌ Ошибка запуска"
    fi
}

# Сброс проекта (полное удаление и пересоздание)
reset_project() {
    print_header "СБРОС ПРОЕКТА"
    print_warning "Это удалит все контейнеры и образы проекта!"
    read -p "Вы уверены? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker stop $CONTAINER_NAME 2>/dev/null
        docker rm $CONTAINER_NAME 2>/dev/null
        docker rmi $IMAGE_NAME 2>/dev/null
        docker-compose down -v 2>/dev/null
        print_success "Проект сброшен"
    fi
}

# =============================================
#   8. СОЗДАНИЕ ФАЙЛОВ ПРОЕКТА
# =============================================

# Создание Dockerfile
create_dockerfile() {
    if [ -f "Dockerfile" ]; then
        print_warning "Dockerfile уже существует"
        read -p "Перезаписать? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    cat > Dockerfile << 'EOF'
FROM nginx:alpine
LABEL maintainer="docker-student@example.com"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
EOF
    print_success "Dockerfile создан"
}

# Создание index.html
create_index() {
    if [ -f "index.html" ]; then
        print_warning "index.html уже существует"
        read -p "Перезаписать? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Simple App</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background: #1e3c72; color: white; }
        h1 { font-size: 48px; }
        .container { background: rgba(255,255,255,0.1); padding: 40px; border-radius: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Docker работает!</h1>
        <p>Проект запущен с помощью start.sh</p>
        <p>Контейнер: <strong><?php echo gethostname(); ?></strong></p>
    </div>
</body>
</html>
EOF
    print_success "index.html создан"
}

# Создание docker-compose.yml
create_compose() {
    if [ -f "docker-compose.yml" ]; then
        print_warning "docker-compose.yml уже существует"
        read -p "Перезаписать? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  web:
    build: .
    container_name: web-server
    ports:
      - "8080:80"
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html
    restart: unless-stopped
EOF
    print_success "docker-compose.yml создан"
}

# Создание всех файлов проекта
create_all_files() {
    print_header "СОЗДАНИЕ ФАЙЛОВ ПРОЕКТА"
    create_dockerfile
    create_index
    create_compose
    print_success "Все файлы проекта созданы!"
}

# =============================================
#   9. УЧЕБНЫЕ КОМАНДЫ (ДЕМОНСТРАЦИЯ)
# =============================================

# Демонстрация всех команд Docker
docker_tutorial() {
    print_header "🐳 ИЗУЧАЕМ DOCKER - ВСЕ КОМАНДЫ"
    
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║           ПОЛНЫЙ ТУТОРИАЛ ПО КОМАНДАМ DOCKER          ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════╝${NC}\n"
    
    # 1. РАБОТА С ОБРАЗАМИ
    echo -e "${CYAN}📦 1. КОМАНДЫ ДЛЯ РАБОТЫ С ОБРАЗАМИ:${NC}"
    echo "   • docker search nginx           - поиск образа"
    echo "   • docker pull nginx:alpine      - загрузка образа"
    echo "   • docker images                 - просмотр образов"
    echo "   • docker build -t my-app .      - сборка образа"
    echo "   • docker rmi image_id           - удаление образа"
    echo "   • docker image prune            - очистка неиспользуемых\n"
    
    # 2. РАБОТА С КОНТЕЙНЕРАМИ
    echo -e "${CYAN}🔧 2. КОМАНДЫ ДЛЯ РАБОТЫ С КОНТЕЙНЕРАМИ:${NC}"
    echo "   • docker run -d --name web -p 80:80 nginx  - запуск"
    echo "   • docker ps                     - запущенные контейнеры"
    echo "   • docker ps -a                 - все контейнеры"
    echo "   • docker stop web              - остановка"
    echo "   • docker start web             - запуск остановленного"
    echo "   • docker restart web           - перезапуск"
    echo "   • docker rm web                - удаление"
    echo "   • docker container prune       - удаление остановленных\n"
    
    # 3. РАБОТА ВНУТРИ КОНТЕЙНЕРА
    echo -e "${CYAN}💻 3. КОМАНДЫ ДЛЯ РАБОТЫ ВНУТРИ КОНТЕЙНЕРА:${NC}"
    echo "   • docker exec -it web sh       - войти в контейнер"
    echo "   • docker logs web              - просмотр логов"
    echo "   • docker logs -f web           - логи в реальном времени"
    echo "   • docker stats                 - статистика ресурсов"
    echo "   • docker top web               - процессы в контейнере\n"
    
    # 4. РАБОТА С ТОМАМИ
    echo -e "${CYAN}💾 4. КОМАНДЫ ДЛЯ РАБОТЫ С ТОМАМИ:${NC}"
    echo "   • docker volume create my-vol  - создание тома"
    echo "   • docker volume ls             - просмотр томов"
    echo "   • docker volume rm my-vol      - удаление тома"
    echo "   • docker volume prune          - очистка томов"
    echo "   • docker run -v my-vol:/data   - монтирование тома\n"
    
    # 5. DOCKER COMPOSE
    echo -e "${CYAN}🚢 5. КОМАНДЫ DOCKER COMPOSE:${NC}"
    echo "   • docker-compose up -d        - запуск проекта"
    echo "   • docker-compose down         - остановка проекта"
    echo "   • docker-compose ps           - список сервисов"
    echo "   • docker-compose logs -f      - логи всех сервисов"
    echo "   • docker-compose exec web sh  - выполнить команду"
    echo "   • docker-compose build        - пересборка образов\n"
    
    # 6. СИСТЕМНЫЕ КОМАНДЫ
    echo -e "${CYAN}⚙️ 6. СИСТЕМНЫЕ КОМАНДЫ:${NC}"
    echo "   • docker version              - версия Docker"
    echo "   • docker info                 - информация о системе"
    echo "   • docker system df            - использование диска"
    echo "   • docker system prune -a -f   - полная очистка\n"
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Используйте ./start.sh для выполнения любой из этих команд!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}\n"
}

# =============================================
#   ГЛАВНОЕ МЕНЮ
# =============================================

show_menu() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║           🐳 DOCKER SIMPLE APP - УПРАВЛЕНИЕ               ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${GREEN}1.${NC}  🚀 Быстрый старт (всё одной командой)"
    echo -e "${GREEN}2.${NC}  📦 Работа с образами"
    echo -e "${GREEN}3.${NC}  🔧 Работа с контейнерами"
    echo -e "${GREEN}4.${NC}  💻 Работа внутри контейнера"
    echo -e "${GREEN}5.${NC}  💾 Работа с томами"
    echo -e "${GREEN}6.${NC}  🚢 Docker Compose"
    echo -e "${GREEN}7.${NC}  📊 Диагностика и информация"
    echo -e "${GREEN}8.${NC}  📁 Создать файлы проекта"
    echo -e "${GREEN}9.${NC}  📚 Docker туториал"
    echo -e "${GREEN}0.${NC}  🧹 Очистка и сброс"
    echo -e "${RED}q.${NC}  ❌ Выход"
    echo ""
    echo -e "${YELLOW}────────────────────────────────────────────────────${NC}"
    echo -e "${BLUE}Проект:${NC} $PROJECT_NAME"
    echo -e "${BLUE}Порт:${NC} $PORT"
    echo -e "${YELLOW}────────────────────────────────────────────────────${NC}"
    echo ""
    read -p "Выберите опцию: " choice
}

# =============================================
#   ОСНОВНОЙ ЦИКЛ ПРОГРАММЫ
# =============================================

# Проверка наличия аргументов командной строки
if [ $# -gt 0 ]; then
    # Если есть аргументы, выполняем соответствующую команду
    case $1 in
        "quick") quick_start ;;
        "build") build_image ;;
        "run") run_container ;;
        "stop") stop_container ;;
        "start") start_container ;;
        "logs") follow_logs ;;
        "status") check_status ;;
        "clean") cleanup ;;
        "tutorial") docker_tutorial ;;
        *) print_error "Неизвестная команда: $1" ;;
    esac
    exit 0
fi

# Интерактивный режим с меню
while true; do
    show_menu
    
    case $choice in
        1)  # Быстрый старт
            quick_start
            ;;
            
        2)  # Работа с образами
            clear
            echo -e "\n${CYAN}━━━━ РАБОТА С ОБРАЗАМИ ━━━━${NC}"
            echo "1. Поиск образов (docker search)"
            echo "2. Загрузка образа (docker pull)"
            echo "3. Просмотр образов (docker images)"
            echo "4. Сборка образа (docker build)"
            echo "5. Сборка с тегом"
            echo "6. Удаление образа (docker rmi)"
            echo "7. Очистка неиспользуемых образов"
            echo "8. Назад"
            read -p "Выберите: " img_choice
            case $img_choice in
                1) search_images ;;
                2) pull_image ;;
                3) list_images ;;
                4) build_image ;;
                5) build_image_with_tag ;;
                6) remove_image ;;
                7) prune_images ;;
                8) continue ;;
            esac
            ;;
            
        3)  # Работа с контейнерами
            clear
            echo -e "\n${CYAN}━━━━ РАБОТА С КОНТЕЙНЕРАМИ ━━━━${NC}"
            echo "1. Запуск контейнера (docker run)"
            echo "2. Запуск с интерактивной оболочкой"
            echo "3. Просмотр запущенных контейнеров"
            echo "4. Просмотр всех контейнеров"
            echo "5. Остановка контейнера"
            echo "6. Запуск остановленного контейнера"
            echo "7. Перезапуск контейнера"
            echo "8. Удаление контейнера"
            echo "9. Удаление всех остановленных"
            echo "10. Назад"
            read -p "Выберите: " cont_choice
            case $cont_choice in
                1) run_container ;;
                2) run_interactive ;;
                3) list_containers ;;
                4) list_all_containers ;;
                5) stop_container ;;
                6) start_container ;;
                7) restart_container ;;
                8) remove_container ;;
                9) remove_all_stopped ;;
                10) continue ;;
            esac
            ;;
            
        4)  # Работа внутри контейнера
            clear
            echo -e "\n${CYAN}━━━━ РАБОТА ВНУТРИ КОНТЕЙНЕРА ━━━━${NC}"
            echo "1. Войти в контейнер (docker exec)"
            echo "2. Просмотр логов"
            echo "3. Логи в реальном времени"
            echo "4. Статистика ресурсов"
            echo "5. Процессы в контейнере"
            echo "6. Тестирование приложения"
            echo "7. Назад"
            read -p "Выберите: " exec_choice
            case $exec_choice in
                1) exec_container ;;
                2) show_logs ;;
                3) follow_logs ;;
                4) show_stats ;;
                5) show_processes ;;
                6) test_app ;;
                7) continue ;;
            esac
            ;;
            
        5)  # Работа с томами
            clear
            echo -e "\n${CYAN}━━━━ РАБОТА С ТОМАМИ ━━━━${NC}"
            echo "1. Создание тома"
            echo "2. Просмотр томов"
            echo "3. Удаление тома"
            echo "4. Очистка неиспользуемых томов"
            echo "5. Назад"
            read -p "Выберите: " vol_choice
            case $vol_choice in
                1) create_volume ;;
                2) list_volumes ;;
                3) remove_volume ;;
                4) prune_volumes ;;
                5) continue ;;
            esac
            ;;
            
        6)  # Docker Compose
            clear
            echo -e "\n${CYAN}━━━━ DOCKER COMPOSE ━━━━${NC}"
            echo "1. Запуск compose"
            echo "2. Сборка и запуск"
            echo "3. Остановка compose"
            echo "4. Остановка с удалением томов"
            echo "5. Просмотр compose контейнеров"
            echo "6. Просмотр логов"
            echo "7. Логи в реальном времени"
            echo "8. Назад"
            read -p "Выберите: " comp_choice
            case $comp_choice in
                1) compose_up ;;
                2) compose_up_build ;;
                3) compose_down ;;
                4) compose_down_volumes ;;
                5) compose_ps ;;
                6) compose_logs ;;
                7) compose_logs_follow ;;
                8) continue ;;
            esac
            ;;
            
        7)  # Диагностика
            clear
            echo -e "\n${CYAN}━━━━ ДИАГНОСТИКА ━━━━${NC}"
            echo "1. Статус проекта"
            echo "2. Информация о Docker"
            echo "3. Тестирование приложения"
            echo "4. Статистика использования"
            echo "5. Назад"
            read -p "Выберите: " diag_choice
            case $diag_choice in
                1) check_status ;;
                2) docker_info ;;
                3) test_app ;;
                4) show_stats ;;
                5) continue ;;
            esac
            ;;
            
        8)  # Создание файлов
            clear
            echo -e "\n${CYAN}━━━━ СОЗДАНИЕ ФАЙЛОВ ━━━━${NC}"
            echo "1. Создать все файлы"
            echo "2. Создать только Dockerfile"
            echo "3. Создать только index.html"
            echo "4. Создать только docker-compose.yml"
            echo "5. Назад"
            read -p "Выберите: " file_choice
            case $file_choice in
                1) create_all_files ;;
                2) create_dockerfile ;;
                3) create_index ;;
                4) create_compose ;;
                5) continue ;;
            esac
            ;;
            
        9)  # Docker туториал
            docker_tutorial
            ;;
            
        0)  # Очистка и сброс
            clear
            echo -e "\n${CYAN}━━━━ ОЧИСТКА И СБРОС ━━━━${NC}"
            echo "1. Сброс проекта"
            echo "2. Полная очистка системы"
            echo "3. Очистка только образов"
            echo "4. Очистка только контейнеров"
            echo "5. Очистка только томов"
            echo "6. Назад"
            read -p "Выберите: " clean_choice
            case $clean_choice in
                1) reset_project ;;
                2) cleanup ;;
                3) prune_images ;;
                4) remove_all_stopped ;;
                5) prune_volumes ;;
                6) continue ;;
            esac
            ;;
            
        q|Q)  # Выход
            echo -e "\n${GREEN}До свидания! 🐳${NC}"
            exit 0
            ;;
            
        *)  # Неверный выбор
            print_error "Неверный выбор!"
            sleep 2
            ;;
    esac
    
    echo -e "\n${YELLOW}Нажмите Enter для продолжения...${NC}"
    read
done