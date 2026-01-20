# Products&Inventory - Development Makefile
# Usage: make <target>

.PHONY: help install up down restart shell db-shell migrate seed test lint analyze fresh logs

# ===========================================
# VARIABLES
# ===========================================
DOCKER_COMPOSE = docker compose
EXEC_APP = $(DOCKER_COMPOSE) exec app
EXEC_DB = $(DOCKER_COMPOSE) exec db

# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RED    := $(shell tput -Txterm setaf 1)
RESET  := $(shell tput -Txterm sgr0)

# ===========================================
# HELP
# ===========================================
help: ## Show this help message
	@echo ''
	@echo '${GREEN}Products&Inventory - Development Commands${RESET}'
	@echo ''
	@echo 'Usage:'
	@echo '  make ${YELLOW}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*##"; } /^[a-zA-Z_-]+:.*?##/ { printf "  ${YELLOW}%-20s${RESET} %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ''

# ===========================================
# INSTALLATION
# ===========================================
install: ## Full project installation from scratch
	@echo '${GREEN}Installing Products&Inventory...${RESET}'
	@echo ''
	@echo '${YELLOW}Step 1: Creating environment file...${RESET}'
	@cp -n .env.example .env 2>/dev/null || echo '.env already exists'
	@echo ''
	@echo '${YELLOW}Step 2: Building Docker images...${RESET}'
	@$(DOCKER_COMPOSE) build
	@echo ''
	@echo '${YELLOW}Step 3: Starting containers...${RESET}'
	@$(DOCKER_COMPOSE) up -d
	@echo ''
	@echo '${YELLOW}Step 4: Waiting for database...${RESET}'
	@sleep 10
	@echo ''
	@echo '${YELLOW}Step 5: Installing Composer dependencies...${RESET}'
	@$(EXEC_APP) composer install
	@echo ''
	@echo '${YELLOW}Step 6: Generating application key...${RESET}'
	@$(EXEC_APP) php artisan key:generate
	@echo ''
	@echo '${YELLOW}Step 7: Running migrations...${RESET}'
	@$(EXEC_APP) php artisan migrate --seed
	@echo ''
	@echo '${YELLOW}Step 8: Creating storage link...${RESET}'
	@$(EXEC_APP) php artisan storage:link
	@echo ''
	@echo '${GREEN}Installation complete!${RESET}'
	@echo ''
	@echo 'Access the application at: ${YELLOW}http://localhost:8080${RESET}'
	@echo 'Mailpit interface at:      ${YELLOW}http://localhost:8025${RESET}'
	@echo ''

# ===========================================
# DOCKER MANAGEMENT
# ===========================================
up: ## Start all containers
	@$(DOCKER_COMPOSE) up -d
	@echo '${GREEN}Containers started${RESET}'

down: ## Stop all containers
	@$(DOCKER_COMPOSE) down
	@echo '${YELLOW}Containers stopped${RESET}'

restart: ## Restart all containers
	@$(DOCKER_COMPOSE) restart
	@echo '${GREEN}Containers restarted${RESET}'

build: ## Rebuild Docker images (no cache)
	@$(DOCKER_COMPOSE) build --no-cache
	@echo '${GREEN}Images rebuilt${RESET}'

logs: ## Show container logs (follow mode)
	@$(DOCKER_COMPOSE) logs -f

ps: ## Show running containers
	@$(DOCKER_COMPOSE) ps

# ===========================================
# SHELL ACCESS
# ===========================================
shell: ## Access the PHP container shell
	@$(EXEC_APP) sh

db-shell: ## Access MariaDB shell
	@$(EXEC_DB) mysql -u laravel -psecret products_inventory

redis-shell: ## Access Redis CLI
	@$(DOCKER_COMPOSE) exec redis redis-cli

# ===========================================
# LARAVEL ARTISAN
# ===========================================
migrate: ## Run database migrations
	@$(EXEC_APP) php artisan migrate
	@echo '${GREEN}Migrations completed${RESET}'

migrate-fresh: ## Fresh migration with seeds
	@$(EXEC_APP) php artisan migrate:fresh --seed
	@echo '${GREEN}Database refreshed${RESET}'

seed: ## Run database seeders
	@$(EXEC_APP) php artisan db:seed
	@echo '${GREEN}Seeding completed${RESET}'

fresh: migrate-fresh ## Alias for migrate-fresh

rollback: ## Rollback last migration
	@$(EXEC_APP) php artisan migrate:rollback
	@echo '${YELLOW}Migration rolled back${RESET}'

# ===========================================
# CACHE MANAGEMENT
# ===========================================
cache-clear: ## Clear all Laravel caches
	@$(EXEC_APP) php artisan cache:clear
	@$(EXEC_APP) php artisan config:clear
	@$(EXEC_APP) php artisan route:clear
	@$(EXEC_APP) php artisan view:clear
	@echo '${GREEN}Caches cleared${RESET}'

optimize: ## Optimize the application for production
	@$(EXEC_APP) php artisan config:cache
	@$(EXEC_APP) php artisan route:cache
	@$(EXEC_APP) php artisan view:cache
	@echo '${GREEN}Application optimized${RESET}'

# ===========================================
# TESTING
# ===========================================
test: ## Run all tests
	@$(EXEC_APP) php artisan test
	@echo '${GREEN}Tests completed${RESET}'

test-coverage: ## Run tests with coverage report
	@$(EXEC_APP) php artisan test --coverage
	@echo '${GREEN}Coverage report generated${RESET}'

test-filter: ## Run specific test (usage: make test-filter FILTER=ProductTest)
	@$(EXEC_APP) php artisan test --filter=$(FILTER)

test-parallel: ## Run tests in parallel
	@$(EXEC_APP) php artisan test --parallel

# ===========================================
# CODE QUALITY
# ===========================================
lint: ## Run PHP CS Fixer and fix code style
	@$(EXEC_APP) ./vendor/bin/pint
	@echo '${GREEN}Code style fixed${RESET}'

lint-check: ## Check code style without fixing
	@$(EXEC_APP) ./vendor/bin/pint --test

analyze: ## Run PHPStan static analysis
	@$(EXEC_APP) ./vendor/bin/phpstan analyse --memory-limit=2G
	@echo '${GREEN}Static analysis completed${RESET}'

quality: lint-check analyze ## Run all quality checks
	@echo '${GREEN}Quality checks completed${RESET}'

# ===========================================
# COMPOSER
# ===========================================
composer-install: ## Install Composer dependencies
	@$(EXEC_APP) composer install
	@echo '${GREEN}Dependencies installed${RESET}'

composer-update: ## Update Composer dependencies
	@$(EXEC_APP) composer update
	@echo '${GREEN}Dependencies updated${RESET}'

composer-dump: ## Dump Composer autoload
	@$(EXEC_APP) composer dump-autoload -o
	@echo '${GREEN}Autoload dumped${RESET}'

composer-audit: ## Run Composer security audit
	@$(EXEC_APP) composer audit
	@echo '${GREEN}Security audit completed${RESET}'

# ===========================================
# ARTISAN COMMANDS
# ===========================================
artisan: ## Run artisan command (usage: make artisan CMD="make:model Product")
	@$(EXEC_APP) php artisan $(CMD)

tinker: ## Open Laravel Tinker
	@$(EXEC_APP) php artisan tinker

# ===========================================
# QUEUE WORKERS
# ===========================================
queue-work: ## Start queue worker
	@$(EXEC_APP) php artisan queue:work --tries=3

queue-listen: ## Listen to queue (for development)
	@$(EXEC_APP) php artisan queue:listen

queue-restart: ## Restart queue workers
	@$(EXEC_APP) php artisan queue:restart
	@echo '${GREEN}Queue workers restarted${RESET}'

# ===========================================
# UTILITIES
# ===========================================
permissions: ## Fix storage permissions
	@$(EXEC_APP) chmod -R 775 storage bootstrap/cache
	@echo '${GREEN}Permissions fixed${RESET}'

ide-helper: ## Generate IDE helper files
	@$(EXEC_APP) php artisan ide-helper:generate
	@$(EXEC_APP) php artisan ide-helper:models -N
	@$(EXEC_APP) php artisan ide-helper:meta
	@echo '${GREEN}IDE helpers generated${RESET}'

# ===========================================
# CLEANUP
# ===========================================
clean: ## Remove all containers and volumes
	@$(DOCKER_COMPOSE) down -v
	@echo '${YELLOW}Containers and volumes removed${RESET}'

clean-all: clean ## Remove everything including images
	@docker system prune -af
	@echo '${RED}All Docker resources cleaned${RESET}'

# ===========================================
# DEPLOY PREPARATION
# ===========================================
deploy-check: ## Run pre-deployment checks
	@echo '${YELLOW}Running pre-deployment checks...${RESET}'
	@echo ''
	@echo 'Tests:'
	@$(EXEC_APP) php artisan test || (echo '${RED}Tests failed${RESET}' && exit 1)
	@echo ''
	@echo 'Code Style:'
	@$(EXEC_APP) ./vendor/bin/pint --test || (echo '${RED}Style issues found${RESET}' && exit 1)
	@echo ''
	@echo 'Static Analysis:'
	@$(EXEC_APP) ./vendor/bin/phpstan analyse --memory-limit=2G || (echo '${RED}Analysis failed${RESET}' && exit 1)
	@echo ''
	@echo 'Security Audit:'
	@$(EXEC_APP) composer audit || (echo '${RED}Security issues found${RESET}' && exit 1)
	@echo ''
	@echo '${GREEN}All checks passed! Ready for deployment.${RESET}'
