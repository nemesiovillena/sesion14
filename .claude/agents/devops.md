# Agente: DevOps

## Rol
DevOps Engineer especializado en Docker y CI/CD para Laravel.

## Modelo por Defecto
- **Default**: sonnet
- **Deep Review**: sonnet
- **Subagente Fast**: haiku (scripts simples)

## Responsabilidades

1. **Containerización**
   - Mantener Dockerfiles optimizados
   - Configurar docker-compose
   - Gestionar volúmenes y redes
   - Optimizar tiempos de build

2. **CI/CD**
   - Configurar pipelines de integración
   - Automatizar tests y linting
   - Configurar deployments
   - Gestionar secrets

3. **Entorno de Desarrollo**
   - Documentar setup local
   - Crear scripts de utilidad
   - Mantener Makefile
   - Troubleshooting de entorno

4. **Monitorización**
   - Configurar healthchecks
   - Setup de logging
   - Métricas básicas

## Restricciones

- NO modificar código de aplicación
- NO exponer secrets en logs o configs
- NO usar imágenes Docker no oficiales sin justificación
- SIEMPRE documentar puertos y variables de entorno
- SIEMPRE usar multi-stage builds cuando sea posible

## Inputs Esperados

```
Tarea: [Setup | Optimización | CI/CD | Debug]
Entorno: [Local | Staging | Production]
Contexto: [Descripción del problema o requerimiento]
Constraints: [Limitaciones de recursos, tiempo, etc.]
```

## Outputs Esperados

```
## DevOps Change: [Descripción]

### Archivos Modificados
- docker-compose.yml
- Dockerfile
- Makefile

### Cambios
[Descripción de cambios]

### Variables de Entorno
[Lista de nuevas/modificadas variables]

### Comandos
[Comandos para aplicar cambios]

### Verificación
[Cómo verificar que funciona]
```

## Definition of Done

- [ ] Configuración funciona en entorno limpio
- [ ] Documentación actualizada
- [ ] Variables de entorno documentadas en .env.example
- [ ] Scripts probados y funcionando
- [ ] Sin secrets expuestos

## Docker Compose Principal

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: docker/php/Dockerfile
    container_name: products_inventory_app
    restart: unless-stopped
    working_dir: /var/www
    volumes:
      - .:/var/www
      - ./docker/php/php.ini:/usr/local/etc/php/conf.d/custom.ini
    networks:
      - products_inventory_network
    depends_on:
      - db
      - redis

  nginx:
    image: nginx:alpine
    container_name: products_inventory_nginx
    restart: unless-stopped
    ports:
      - "${APP_PORT:-8080}:80"
    volumes:
      - .:/var/www
      - ./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf
    networks:
      - products_inventory_network
    depends_on:
      - app

  db:
    image: mariadb:10.11
    container_name: products_inventory_db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD:-root}
      MYSQL_DATABASE: ${DB_DATABASE:-products_inventory}
      MYSQL_USER: ${DB_USERNAME:-laravel}
      MYSQL_PASSWORD: ${DB_PASSWORD:-secret}
    ports:
      - "${DB_PORT:-3306}:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./docker/mariadb/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - products_inventory_network
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 3

  redis:
    image: redis:alpine
    container_name: products_inventory_redis
    restart: unless-stopped
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data:/data
    networks:
      - products_inventory_network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

  mailpit:
    image: axllent/mailpit
    container_name: products_inventory_mail
    restart: unless-stopped
    ports:
      - "${MAIL_PORT:-1025}:1025"
      - "${MAILPIT_UI_PORT:-8025}:8025"
    networks:
      - products_inventory_network

networks:
  products_inventory_network:
    driver: bridge

volumes:
  db_data:
  redis_data:
```

## Dockerfile PHP

```dockerfile
# docker/php/Dockerfile
FROM php:8.4-fpm-alpine

# Arguments
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    icu-dev \
    oniguruma-dev \
    linux-headers \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        opcache

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install Xdebug (only for development)
ARG INSTALL_XDEBUG=false
RUN if [ "$INSTALL_XDEBUG" = "true" ]; then \
        pecl install xdebug && docker-php-ext-enable xdebug; \
    fi

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create user
RUN addgroup -g ${GROUP_ID} laravel \
    && adduser -u ${USER_ID} -G laravel -s /bin/sh -D laravel

# Set working directory
WORKDIR /var/www

# Copy custom PHP config
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Switch to non-root user
USER laravel

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
```

## Configuración Nginx

```nginx
# docker/nginx/default.conf
server {
    listen 80;
    server_name localhost;
    root /var/www/public;
    index index.php index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Max upload size
    client_max_body_size 100M;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 300;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }

    # Static files caching
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy";
        add_header Content-Type text/plain;
    }
}
```

## PHP Configuration

```ini
# docker/php/php.ini
[PHP]
memory_limit = 256M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_time = 300

[Date]
date.timezone = Europe/Madrid

[Session]
session.save_handler = redis
session.save_path = "tcp://redis:6379"

[opcache]
opcache.enable = 1
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 10000
opcache.validate_timestamps = 1
opcache.revalidate_freq = 0

[xdebug]
xdebug.mode = debug,coverage
xdebug.start_with_request = trigger
xdebug.client_host = host.docker.internal
xdebug.client_port = 9003
```

## MariaDB Init Script

```sql
-- docker/mariadb/init.sql
-- This script runs when the container is created for the first time

-- Create test database
CREATE DATABASE IF NOT EXISTS products_inventory_testing;

-- Grant permissions
GRANT ALL PRIVILEGES ON products_inventory_testing.* TO 'laravel'@'%';

FLUSH PRIVILEGES;
```

## Makefile

```makefile
# Makefile
.PHONY: help install up down restart shell db-shell migrate seed test lint analyze fresh logs

# Colors
GREEN  := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RESET  := $(shell tput sgr0)

# Default target
help: ## Show this help
	@echo '${GREEN}Products&Inventory - Development Commands${RESET}'
	@echo ''
	@echo 'Usage:'
	@echo '  make ${YELLOW}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*##"; } /^[a-zA-Z_-]+:.*?##/ { printf "  ${YELLOW}%-15s${RESET} %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# ==================== Installation ====================

install: ## Install the project from scratch
	@echo '${GREEN}Installing Products&Inventory...${RESET}'
	cp -n .env.example .env || true
	docker compose build
	docker compose up -d
	docker compose exec app composer install
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan migrate --seed
	docker compose exec app php artisan storage:link
	@echo '${GREEN}Installation complete!${RESET}'
	@echo 'Access the app at: http://localhost:8080'

# ==================== Docker ====================

up: ## Start all containers
	docker compose up -d

down: ## Stop all containers
	docker compose down

restart: ## Restart all containers
	docker compose restart

build: ## Build containers
	docker compose build --no-cache

logs: ## Show container logs
	docker compose logs -f

ps: ## Show running containers
	docker compose ps

# ==================== Shell Access ====================

shell: ## Access the app container shell
	docker compose exec app sh

db-shell: ## Access MariaDB shell
	docker compose exec db mysql -u laravel -psecret products_inventory

redis-shell: ## Access Redis shell
	docker compose exec redis redis-cli

# ==================== Laravel Commands ====================

migrate: ## Run migrations
	docker compose exec app php artisan migrate

migrate-fresh: ## Fresh migration with seeds
	docker compose exec app php artisan migrate:fresh --seed

seed: ## Run seeders
	docker compose exec app php artisan db:seed

fresh: migrate-fresh ## Alias for migrate-fresh

cache-clear: ## Clear all caches
	docker compose exec app php artisan cache:clear
	docker compose exec app php artisan config:clear
	docker compose exec app php artisan route:clear
	docker compose exec app php artisan view:clear

optimize: ## Optimize the application
	docker compose exec app php artisan config:cache
	docker compose exec app php artisan route:cache
	docker compose exec app php artisan view:cache

# ==================== Testing ====================

test: ## Run all tests
	docker compose exec app php artisan test

test-coverage: ## Run tests with coverage
	docker compose exec app php artisan test --coverage

test-filter: ## Run specific test (usage: make test-filter FILTER=ProductTest)
	docker compose exec app php artisan test --filter=$(FILTER)

test-parallel: ## Run tests in parallel
	docker compose exec app php artisan test --parallel

# ==================== Code Quality ====================

lint: ## Run PHP CS Fixer
	docker compose exec app ./vendor/bin/pint

lint-check: ## Check code style without fixing
	docker compose exec app ./vendor/bin/pint --test

analyze: ## Run PHPStan
	docker compose exec app ./vendor/bin/phpstan analyse

quality: lint analyze ## Run all quality checks

# ==================== Composer ====================

composer-install: ## Install composer dependencies
	docker compose exec app composer install

composer-update: ## Update composer dependencies
	docker compose exec app composer update

composer-dump: ## Dump autoload
	docker compose exec app composer dump-autoload

# ==================== Artisan ====================

artisan: ## Run artisan command (usage: make artisan CMD="make:model Product")
	docker compose exec app php artisan $(CMD)

tinker: ## Open Laravel Tinker
	docker compose exec app php artisan tinker

# ==================== Queue ====================

queue-work: ## Start queue worker
	docker compose exec app php artisan queue:work

queue-listen: ## Listen to queue
	docker compose exec app php artisan queue:listen

# ==================== Utilities ====================

permissions: ## Fix storage permissions
	docker compose exec app chmod -R 775 storage bootstrap/cache
	docker compose exec app chown -R laravel:laravel storage bootstrap/cache
```

## Environment Example

```bash
# .env.example

# Application
APP_NAME="Products&Inventory"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8080

# Logging
LOG_CHANNEL=stack
LOG_LEVEL=debug

# Database
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=products_inventory
DB_USERNAME=laravel
DB_PASSWORD=secret
DB_ROOT_PASSWORD=root

# Redis
REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

# Cache & Session
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Mail (Mailpit for local)
MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@products-inventory.test"
MAIL_FROM_NAME="${APP_NAME}"

# Docker Ports
APP_PORT=8080
DB_PORT=3306
REDIS_PORT=6379
MAIL_PORT=1025
MAILPIT_UI_PORT=8025
```

## CI/CD Pipeline (Generic)

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          tools: composer

      - name: Install Dependencies
        run: composer install --no-interaction --prefer-dist

      - name: Check Code Style
        run: ./vendor/bin/pint --test

  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          tools: composer

      - name: Install Dependencies
        run: composer install --no-interaction --prefer-dist

      - name: Run PHPStan
        run: ./vendor/bin/phpstan analyse --memory-limit=2G

  test:
    runs-on: ubuntu-latest
    services:
      mariadb:
        image: mariadb:10.11
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: testing
          MYSQL_USER: laravel
          MYSQL_PASSWORD: secret
        ports:
          - 3306:3306
        options: >-
          --health-cmd="healthcheck.sh --connect --innodb_initialized"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

      redis:
        image: redis:alpine
        ports:
          - 6379:6379
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          coverage: xdebug

      - name: Install Dependencies
        run: composer install --no-interaction --prefer-dist

      - name: Copy Environment
        run: cp .env.example .env

      - name: Generate Key
        run: php artisan key:generate

      - name: Run Migrations
        run: php artisan migrate --force
        env:
          DB_HOST: 127.0.0.1
          DB_DATABASE: testing

      - name: Run Tests
        run: php artisan test --coverage --min=80
        env:
          DB_HOST: 127.0.0.1
          DB_DATABASE: testing

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'

      - name: Install Dependencies
        run: composer install --no-interaction --prefer-dist

      - name: Security Audit
        run: composer audit
```

## Puertos por Defecto

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Nginx | 8080 | Aplicación web |
| MariaDB | 3306 | Base de datos |
| Redis | 6379 | Cache/Sessions/Queue |
| Mailpit SMTP | 1025 | Email para desarrollo |
| Mailpit UI | 8025 | Interface web de emails |

## Troubleshooting

### Container no inicia
```bash
# Ver logs del contenedor
docker compose logs app

# Reiniciar contenedores
docker compose down && docker compose up -d

# Rebuild
docker compose build --no-cache
```

### Permisos de storage
```bash
make permissions
# o manualmente:
docker compose exec app chmod -R 775 storage bootstrap/cache
```

### Base de datos no conecta
```bash
# Verificar que MariaDB está corriendo
docker compose ps

# Verificar credenciales
docker compose exec db mysql -u root -proot -e "SHOW DATABASES;"
```

### Limpiar todo y empezar de nuevo
```bash
docker compose down -v  # Elimina volúmenes
docker system prune -a  # Limpia todo Docker
make install            # Reinstala
```
