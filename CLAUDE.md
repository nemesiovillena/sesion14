# Products&Inventory - Documentación del Proyecto

## Descripción
Ecommerce en Laravel 12 con Docker (PHP 8.4 + MariaDB) diseñado para desarrollo asistido por Claude con agentes y MCPs.

## Documentación del Proyecto

| Documento | Descripción | Path |
|-----------|-------------|------|
| **CLAUDE.md** | Arquitectura, agentes, estrategia de modelos | Este archivo |
| **ROADMAP.md** | Planificación de sprints y deploy | `.claude/ROADMAP.md` |
| **PROGRESS.md** | Seguimiento de progreso por sprint | `.claude/PROGRESS.md` |
| **settings.json** | Configuración de Claude Code | `.claude/settings.json` |

## Quick Start

```bash
# 1. Clonar e instalar
make install

# 2. Ver estado del sprint actual
# /sprint-status

# 3. Iniciar nueva feature
# /new-feature [nombre]

# 4. Actualizar progreso
# /update-progress [sprint] [tarea] [estado]
```

---

# 1) AGENT + MODEL STRATEGY

## Tabla de Asignación de Agentes y Modelos

| Tarea | Agente | Modelo Default | Modelo Deep Review | Subagente Fast | Output Esperado | Definition of Done |
|-------|--------|----------------|-------------------|----------------|-----------------|-------------------|
| **Arquitectura y Diseño** | `@architect` | sonnet | opus | haiku | Documentos de arquitectura, diagramas, decisiones técnicas | Documento aprobado, sin ambigüedades, con justificación de decisiones |
| **Implementación Features** | `@developer` | sonnet | opus | haiku | Código funcional con tests | Tests pasan, código revisado, sin vulnerabilidades conocidas |
| **UI/Frontend** | `@frontend` | sonnet | sonnet | haiku | Vistas Blade, componentes, estilos | Responsive, accesible, consistente con diseño |
| **Testing** | `@tester` | sonnet | sonnet | haiku | Suites de tests, reportes de cobertura | Cobertura >80%, tests E2E críticos implementados |
| **Refactoring** | `@refactor` | sonnet | opus | haiku | Código optimizado sin cambios funcionales | Tests existentes pasan, métricas de calidad mejoradas |
| **Debugging** | `@debugger` | sonnet | opus | haiku | Fix documentado con root cause analysis | Bug resuelto, test de regresión añadido |
| **Seguridad** | `@security` | opus | opus | sonnet | Auditorías, fixes de vulnerabilidades | OWASP Top 10 cubierto, sin vulnerabilidades críticas |
| **Base de Datos** | `@database` | sonnet | opus | haiku | Migraciones, seeders, queries optimizadas | Migraciones reversibles, índices documentados |
| **DevOps/Docker** | `@devops` | sonnet | sonnet | haiku | Configuraciones Docker, CI/CD | Entorno reproducible, pipeline funcional |
| **Documentación** | `@docs` | haiku | sonnet | haiku | README, API docs, guías | Documentación clara, actualizada, sin errores |
| **Code Review** | `@reviewer` | opus | opus | sonnet | Feedback estructurado, aprobación/rechazo | Checklist completo, decisión clara |

## Reglas de Escalado

### Escalado Automático a Deep Review (opus)
Las siguientes tareas SIEMPRE requieren modelo opus:

1. **Pagos y Transacciones**
   - Implementación de pasarelas de pago
   - Lógica de procesamiento de transacciones
   - Manejo de webhooks de pago

2. **Autenticación y Autorización**
   - Sistema de login/registro
   - Gestión de tokens y sesiones
   - Políticas de permisos y roles

3. **Migraciones Críticas**
   - Cambios en tablas con datos de producción
   - Modificaciones de claves foráneas
   - Alteraciones de índices en tablas grandes

4. **Seguridad**
   - Cualquier código que maneje datos sensibles
   - Validación de inputs externos
   - Sanitización de outputs

5. **Decisiones Arquitectónicas**
   - Nuevos bounded contexts
   - Cambios en patrones establecidos
   - Integraciones con servicios externos

### Tareas Delegables a Subagentes Fast (haiku)
Sin riesgo y paralelizables:

1. **Generación de Boilerplate**
   - Crear migrations básicas
   - Scaffolding de Models, Controllers, Requests
   - Generar factories y seeders simples

2. **Tareas Mecánicas**
   - Formateo de código
   - Ordenar imports
   - Generar PHPDoc básico

3. **Búsquedas y Análisis**
   - Localizar archivos por patrón
   - Buscar usos de una clase/método
   - Contar líneas de código

4. **Tests Unitarios Simples**
   - Tests de getters/setters
   - Tests de validaciones básicas
   - Tests de helpers puros

### Criterios de Escalado Default → Deep Review

```
SI cumple CUALQUIERA de estos criterios → Escalar a opus:

1. Toca más de 5 archivos en un commit
2. Modifica lógica de negocio crítica (pagos, auth, pedidos)
3. Cambia estructura de base de datos en producción
4. Implementa nueva integración externa
5. Refactoriza código sin cobertura de tests
6. El desarrollador tiene dudas sobre el approach
7. Es la primera implementación de un patrón nuevo
```

---

# 2) CLAUDE CODE CONFIG

## Estructura de Archivos

```
.claude/
├── settings.json           # Configuración principal
├── agents/
│   ├── architect.md        # Agente de arquitectura
│   ├── developer.md        # Agente de desarrollo
│   ├── tester.md           # Agente de testing
│   ├── security.md         # Agente de seguridad
│   ├── database.md         # Agente de base de datos
│   ├── devops.md           # Agente de DevOps
│   └── reviewer.md         # Agente de code review
├── commands/
│   ├── new-feature.md      # Comando para nuevas features
│   ├── fix-bug.md          # Comando para bugs
│   ├── migrate.md          # Comando para migraciones
│   └── deploy-check.md     # Comando pre-deploy
└── hooks/
    └── pre-commit.sh       # Hook de pre-commit
```

---

# 3) PROJECT ARCHITECTURE (PROPOSAL)

## Bounded Contexts y Dominios

```
┌─────────────────────────────────────────────────────────────────┐
│                     Products&Inventory                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   CATALOG    │  │    CART      │  │   CHECKOUT   │          │
│  │              │  │              │  │              │          │
│  │ - Products   │  │ - CartItems  │  │ - Orders     │          │
│  │ - Categories │  │ - Sessions   │  │ - Payments   │          │
│  │ - Variants   │  │              │  │ - Shipping   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  INVENTORY   │  │    USER      │  │    ADMIN     │          │
│  │              │  │              │  │              │          │
│  │ - Stock      │  │ - Customers  │  │ - Dashboard  │          │
│  │ - Movements  │  │ - Addresses  │  │ - Reports    │          │
│  │ - Alerts     │  │ - Auth       │  │ - Settings   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Estructura de Directorios Laravel

```
app/
├── Actions/                    # Single-purpose action classes
│   ├── Catalog/
│   │   ├── CreateProductAction.php
│   │   └── UpdateStockAction.php
│   ├── Cart/
│   │   ├── AddToCartAction.php
│   │   └── RemoveFromCartAction.php
│   ├── Checkout/
│   │   ├── CreateOrderAction.php
│   │   └── ProcessPaymentAction.php
│   └── User/
│       ├── RegisterUserAction.php
│       └── UpdateProfileAction.php
│
├── Domain/                     # Domain logic (entities, value objects)
│   ├── Catalog/
│   │   ├── Models/
│   │   │   ├── Product.php
│   │   │   ├── Category.php
│   │   │   └── ProductVariant.php
│   │   └── Enums/
│   │       └── ProductStatus.php
│   ├── Cart/
│   │   └── Models/
│   │       ├── Cart.php
│   │       └── CartItem.php
│   ├── Checkout/
│   │   ├── Models/
│   │   │   ├── Order.php
│   │   │   ├── OrderItem.php
│   │   │   └── Payment.php
│   │   └── Enums/
│   │       ├── OrderStatus.php
│   │       └── PaymentStatus.php
│   ├── Inventory/
│   │   └── Models/
│   │       ├── StockMovement.php
│   │       └── StockAlert.php
│   └── User/
│       ├── Models/
│       │   ├── User.php
│       │   └── Address.php
│       └── Enums/
│           └── UserRole.php
│
├── Http/
│   ├── Controllers/
│   │   ├── Web/               # Controllers para vistas Blade
│   │   │   ├── CatalogController.php
│   │   │   ├── CartController.php
│   │   │   ├── CheckoutController.php
│   │   │   └── AccountController.php
│   │   ├── Api/               # Controllers para API JSON
│   │   │   └── V1/
│   │   │       ├── ProductController.php
│   │   │       ├── CartController.php
│   │   │       └── OrderController.php
│   │   └── Admin/             # Controllers del panel admin
│   │       ├── DashboardController.php
│   │       ├── ProductController.php
│   │       ├── OrderController.php
│   │       └── UserController.php
│   │
│   ├── Requests/              # Form Requests para validación
│   │   ├── Catalog/
│   │   │   ├── StoreProductRequest.php
│   │   │   └── UpdateProductRequest.php
│   │   ├── Cart/
│   │   │   └── AddToCartRequest.php
│   │   ├── Checkout/
│   │   │   ├── CreateOrderRequest.php
│   │   │   └── ProcessPaymentRequest.php
│   │   └── User/
│   │       ├── RegisterRequest.php
│   │       └── UpdateProfileRequest.php
│   │
│   ├── Middleware/
│   │   ├── EnsureUserIsAdmin.php
│   │   └── EnsureCartExists.php
│   │
│   └── Resources/             # API Resources
│       ├── ProductResource.php
│       ├── CartResource.php
│       └── OrderResource.php
│
├── Services/                   # Servicios de aplicación
│   ├── PaymentService.php
│   ├── ShippingService.php
│   ├── InventoryService.php
│   └── NotificationService.php
│
├── Jobs/                       # Queue Jobs
│   ├── ProcessPaymentJob.php
│   ├── SendOrderConfirmationJob.php
│   ├── UpdateStockJob.php
│   └── GenerateInvoiceJob.php
│
├── Events/                     # Domain Events
│   ├── OrderCreated.php
│   ├── PaymentProcessed.php
│   ├── StockLow.php
│   └── UserRegistered.php
│
├── Listeners/                  # Event Listeners
│   ├── SendOrderConfirmation.php
│   ├── UpdateInventoryOnOrder.php
│   ├── NotifyAdminOnLowStock.php
│   └── SendWelcomeEmail.php
│
├── Policies/                   # Authorization Policies
│   ├── ProductPolicy.php
│   ├── OrderPolicy.php
│   └── UserPolicy.php
│
└── Exceptions/                 # Custom Exceptions
    ├── InsufficientStockException.php
    ├── PaymentFailedException.php
    └── OrderNotFoundException.php

database/
├── migrations/
├── seeders/
│   ├── DatabaseSeeder.php
│   ├── CategorySeeder.php
│   ├── ProductSeeder.php
│   └── UserSeeder.php
└── factories/
    ├── ProductFactory.php
    ├── CategoryFactory.php
    ├── OrderFactory.php
    └── UserFactory.php

resources/
├── views/
│   ├── layouts/
│   │   ├── app.blade.php
│   │   └── admin.blade.php
│   ├── catalog/
│   ├── cart/
│   ├── checkout/
│   ├── account/
│   ├── admin/
│   └── components/
└── js/
    └── app.js

routes/
├── web.php                    # Rutas web públicas
├── api.php                    # Rutas API v1
├── admin.php                  # Rutas del panel admin
└── auth.php                   # Rutas de autenticación

tests/
├── Unit/
│   ├── Actions/
│   ├── Services/
│   └── Models/
├── Feature/
│   ├── Catalog/
│   ├── Cart/
│   ├── Checkout/
│   └── Admin/
└── E2E/
    ├── CheckoutFlowTest.php
    └── AdminOrderManagementTest.php
```

## Estrategia de Base de Datos

### Diagrama de Tablas Principales

```
┌─────────────────┐       ┌─────────────────┐
│     users       │       │   categories    │
├─────────────────┤       ├─────────────────┤
│ id              │       │ id              │
│ name            │       │ name            │
│ email           │       │ slug            │
│ password        │       │ parent_id (FK)  │
│ role (enum)     │       │ is_active       │
│ email_verified  │       │ sort_order      │
│ created_at      │       │ timestamps      │
│ updated_at      │       └────────┬────────┘
└────────┬────────┘                │
         │                         │
         │       ┌─────────────────┴─────────────────┐
         │       │            products               │
         │       ├───────────────────────────────────┤
         │       │ id                                │
         │       │ category_id (FK)                  │
         │       │ name                              │
         │       │ slug                              │
         │       │ description                       │
         │       │ price (decimal 10,2)              │
         │       │ compare_price (decimal 10,2)      │
         │       │ sku                               │
         │       │ stock_quantity                    │
         │       │ low_stock_threshold               │
         │       │ status (enum: draft/active/out)   │
         │       │ is_featured                       │
         │       │ images (json)                     │
         │       │ attributes (json)                 │
         │       │ timestamps                        │
         │       │ soft_deletes                      │
         │       └───────────────┬───────────────────┘
         │                       │
┌────────┴────────┐    ┌────────┴────────┐
│   addresses     │    │  stock_movements │
├─────────────────┤    ├─────────────────┤
│ id              │    │ id              │
│ user_id (FK)    │    │ product_id (FK) │
│ type (enum)     │    │ quantity        │
│ name            │    │ type (enum)     │
│ line_1          │    │ reference       │
│ line_2          │    │ notes           │
│ city            │    │ created_by (FK) │
│ state           │    │ timestamps      │
│ postal_code     │    └─────────────────┘
│ country         │
│ phone           │
│ is_default      │
│ timestamps      │
└─────────────────┘

┌─────────────────┐       ┌─────────────────┐
│     carts       │       │   cart_items    │
├─────────────────┤       ├─────────────────┤
│ id              │       │ id              │
│ user_id (FK)?   │◄──────│ cart_id (FK)    │
│ session_id      │       │ product_id (FK) │
│ expires_at      │       │ quantity        │
│ timestamps      │       │ price_snapshot  │
└─────────────────┘       │ timestamps      │
                          └─────────────────┘

┌─────────────────┐       ┌─────────────────┐
│     orders      │       │   order_items   │
├─────────────────┤       ├─────────────────┤
│ id              │       │ id              │
│ user_id (FK)    │◄──────│ order_id (FK)   │
│ order_number    │       │ product_id (FK) │
│ status (enum)   │       │ product_name    │
│ subtotal        │       │ quantity        │
│ tax             │       │ unit_price      │
│ shipping_cost   │       │ total           │
│ total           │       │ timestamps      │
│ shipping_addr   │       └─────────────────┘
│ billing_addr    │
│ notes           │       ┌─────────────────┐
│ timestamps      │       │    payments     │
└────────┬────────┘       ├─────────────────┤
         │                │ id              │
         └───────────────►│ order_id (FK)   │
                          │ amount          │
                          │ method (enum)   │
                          │ status (enum)   │
                          │ transaction_id  │
                          │ gateway_response│
                          │ timestamps      │
                          └─────────────────┘
```

### Índices Recomendados

```sql
-- Products
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_sku ON products(sku);
CREATE UNIQUE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_featured ON products(is_featured, status);

-- Orders
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE UNIQUE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created ON orders(created_at);

-- Cart Items
CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX idx_cart_items_product ON cart_items(product_id);

-- Stock Movements
CREATE INDEX idx_stock_movements_product ON stock_movements(product_id);
CREATE INDEX idx_stock_movements_created ON stock_movements(created_at);

-- Addresses
CREATE INDEX idx_addresses_user ON addresses(user_id);
```

## Autenticación y Roles

### Roles del Sistema

```php
enum UserRole: string
{
    case CUSTOMER = 'customer';
    case ADMIN = 'admin';
}
```

### Flujo de Autenticación

```
┌──────────────────────────────────────────────────────────────┐
│                    AUTHENTICATION FLOW                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WEB (Session-based)              API (Token-based)          │
│  ─────────────────────            ──────────────────         │
│                                                              │
│  1. Login Form                    1. POST /api/v1/login      │
│  2. CSRF Token                    2. Return Bearer Token     │
│  3. Session Cookie                3. Sanctum Token           │
│  4. Remember Me (optional)        4. Token Expiry            │
│                                                              │
│  Middleware: auth                 Middleware: auth:sanctum   │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│                    AUTHORIZATION                              │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Policies:                                                   │
│  - ProductPolicy (admin can CRUD, customer can view)         │
│  - OrderPolicy (admin can all, customer can view own)        │
│  - UserPolicy (admin can manage, customer can self)          │
│                                                              │
│  Middleware:                                                 │
│  - EnsureUserIsAdmin (para rutas /admin/*)                   │
│  - EnsureEmailVerified (para checkout)                       │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Enfoque Web / API

### Justificación del Enfoque Híbrido

| Aspecto | Web (Blade) | API (JSON) |
|---------|-------------|------------|
| **Uso** | Tienda pública, Admin | Apps móviles futuras, integraciones |
| **Auth** | Session + CSRF | Sanctum tokens |
| **SEO** | Server-side rendering | N/A |
| **Cache** | Full-page cache posible | Response cache |
| **Estado** | Session + cookies | Stateless |

### Rutas Principales

```
WEB ROUTES (/):
├── /                           # Home (catálogo destacado)
├── /catalog                    # Listado productos
├── /catalog/{slug}             # Detalle producto
├── /cart                       # Ver carrito
├── /checkout                   # Proceso de compra
├── /account                    # Dashboard cliente
├── /account/orders             # Historial pedidos
├── /account/orders/{id}        # Detalle pedido
└── /account/addresses          # Gestión direcciones

ADMIN ROUTES (/admin):
├── /admin                      # Dashboard
├── /admin/products             # CRUD productos
├── /admin/categories           # CRUD categorías
├── /admin/orders               # Gestión pedidos
├── /admin/users                # Gestión usuarios
├── /admin/inventory            # Control stock
└── /admin/settings             # Configuración

API ROUTES (/api/v1):
├── POST   /auth/login          # Login
├── POST   /auth/register       # Registro
├── POST   /auth/logout         # Logout
├── GET    /products            # Listar productos
├── GET    /products/{id}       # Detalle producto
├── GET    /categories          # Listar categorías
├── GET    /cart                # Ver carrito
├── POST   /cart/items          # Añadir al carrito
├── PUT    /cart/items/{id}     # Actualizar cantidad
├── DELETE /cart/items/{id}     # Eliminar del carrito
├── POST   /orders              # Crear pedido
├── GET    /orders              # Mis pedidos
└── GET    /orders/{id}         # Detalle pedido
```

## Observabilidad Mínima

### Logging Strategy

```php
// config/logging.php - Canales configurados

'channels' => [
    'stack' => [
        'driver' => 'stack',
        'channels' => ['daily', 'stderr'],
    ],

    'daily' => [
        'driver' => 'daily',
        'path' => storage_path('logs/laravel.log'),
        'level' => 'debug',
        'days' => 14,
    ],

    // Canal específico para transacciones de pago
    'payments' => [
        'driver' => 'daily',
        'path' => storage_path('logs/payments.log'),
        'level' => 'info',
        'days' => 90,
    ],

    // Canal para auditoría de acciones admin
    'audit' => [
        'driver' => 'daily',
        'path' => storage_path('logs/audit.log'),
        'level' => 'info',
        'days' => 365,
    ],
],
```

### Health Check Endpoint

```php
// GET /health
{
    "status": "healthy",
    "timestamp": "2025-01-20T10:30:00Z",
    "checks": {
        "database": "ok",
        "cache": "ok",
        "queue": "ok",
        "storage": "ok"
    },
    "version": "1.0.0"
}
```

## Estrategia de Testing

### Pirámide de Tests

```
                    ┌─────────┐
                   │   E2E   │  ~10%
                  │  Tests  │  (Checkout flow, Admin CRUD)
                 └─────────┘
                ┌───────────────┐
               │   Feature     │  ~30%
              │    Tests      │  (HTTP, Controllers, Middleware)
             └───────────────┘
            ┌─────────────────────┐
           │      Unit Tests     │  ~60%
          │  (Actions, Services, │
         │   Models, Helpers)    │
        └─────────────────────────┘
```

### Cobertura Mínima por Módulo

| Módulo | Cobertura Mínima | Tipos de Tests |
|--------|------------------|----------------|
| Actions | 90% | Unit |
| Services | 85% | Unit + Integration |
| Models | 80% | Unit |
| Controllers | 75% | Feature |
| Checkout | 95% | Feature + E2E |
| Payments | 95% | Feature + E2E |
| Auth | 90% | Feature |

### Convenciones de Testing

```php
// Nomenclatura de tests
test('it creates a product with valid data')
test('it fails when stock is insufficient')
test('guest cannot access admin dashboard')

// Estructura de tests
tests/
├── Unit/
│   ├── Actions/
│   │   ├── CreateProductActionTest.php
│   │   └── ProcessPaymentActionTest.php
│   └── Services/
│       └── InventoryServiceTest.php
├── Feature/
│   ├── Catalog/
│   │   ├── ProductListingTest.php
│   │   └── ProductDetailTest.php
│   ├── Cart/
│   │   └── CartManagementTest.php
│   └── Checkout/
│       └── OrderCreationTest.php
└── E2E/
    └── FullCheckoutFlowTest.php
```

## Seguridad Básica

### OWASP Top 10 - Mitigaciones

| Vulnerabilidad | Mitigación en Laravel |
|----------------|----------------------|
| Injection | Eloquent ORM, Query Builder, Prepared Statements |
| Broken Auth | Sanctum, Rate Limiting, Password Hashing |
| Sensitive Data | HTTPS, Encrypted columns, .env |
| XXE | JSON APIs (no XML) |
| Broken Access | Policies, Gates, Middleware |
| Security Misconfig | Config validation, .env.example |
| XSS | Blade auto-escaping, CSP headers |
| Insecure Deserialization | Signed URLs, Encrypted cookies |
| Vulnerable Components | Composer audit, Dependabot |
| Insufficient Logging | Multi-channel logging, Audit trail |

### Headers de Seguridad

```php
// Middleware de seguridad
public function handle($request, Closure $next)
{
    $response = $next($request);

    return $response
        ->header('X-Content-Type-Options', 'nosniff')
        ->header('X-Frame-Options', 'SAMEORIGIN')
        ->header('X-XSS-Protection', '1; mode=block')
        ->header('Referrer-Policy', 'strict-origin-when-cross-origin')
        ->header('Permissions-Policy', 'geolocation=(), microphone=()');
}
```

### Validación de Inputs

```php
// Anti-Prompt Injection para campos de texto
// Aplicar en Form Requests que aceptan texto libre

'name' => ['required', 'string', 'max:255', new SafeTextRule()],
'description' => ['required', 'string', 'max:5000', new SafeHtmlRule()],
'notes' => ['nullable', 'string', 'max:1000', 'regex:/^[^<>{}]*$/'],
```

## Pipeline CI/CD Genérico

```yaml
# .github/workflows/ci.yml (ejemplo conceptual)

stages:
  - lint
  - test
  - security
  - build
  - deploy

lint:
  - php-cs-fixer
  - phpstan (level 8)
  - eslint (si hay JS)

test:
  - phpunit --coverage
  - coverage threshold: 80%

security:
  - composer audit
  - npm audit
  - OWASP dependency check

build:
  - composer install --no-dev
  - npm run build
  - optimize autoloader

deploy:
  - staging: auto on merge to develop
  - production: manual approval on merge to main
```

---

# 4) DOCKER & LOCAL DEV

## Estructura de Archivos Docker

```
docker/
├── php/
│   └── Dockerfile
├── nginx/
│   └── default.conf
└── mariadb/
    └── init.sql

docker-compose.yml
Makefile
.env.example
```

---

# 5) BACKLOG & NEXT STEPS

## Backlog Nivel A: MVP

### Iteración 1: Fundamentos (Base del proyecto)
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-001 | Como desarrollador, quiero tener el proyecto Laravel configurado con Docker para comenzar el desarrollo | - Laravel 12 instalado y funcionando<br>- Docker compose levanta PHP + MariaDB<br>- Migrations ejecutan correctamente<br>- Tests base pasan | Alta |
| US-002 | Como desarrollador, quiero la estructura de dominios creada para organizar el código | - Carpetas Domain/, Actions/, Services/ creadas<br>- Autoload configurado<br>- README de arquitectura documentado | Alta |

### Iteración 2: Catálogo
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-003 | Como visitante, quiero ver un listado de productos para explorar la tienda | - Página /catalog muestra productos activos<br>- Paginación de 12 productos<br>- Filtro por categoría funciona<br>- Ordenar por precio/nombre | Alta |
| US-004 | Como visitante, quiero ver el detalle de un producto para decidir si comprarlo | - Página /catalog/{slug} muestra toda la info<br>- Imágenes del producto visibles<br>- Precio y stock mostrados<br>- Botón "Añadir al carrito" presente | Alta |
| US-005 | Como admin, quiero gestionar productos para mantener el catálogo actualizado | - CRUD completo de productos<br>- Subida de imágenes<br>- Validación de campos<br>- Soft delete implementado | Alta |

### Iteración 3: Carrito
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-006 | Como visitante, quiero añadir productos al carrito para prepararlos para compra | - Botón añade producto al carrito<br>- Cantidad actualizable<br>- Carrito persiste en sesión<br>- Feedback visual de confirmación | Alta |
| US-007 | Como visitante, quiero ver mi carrito para revisar antes de pagar | - Página /cart muestra items<br>- Total calculado correctamente<br>- Puedo eliminar items<br>- Puedo modificar cantidades | Alta |

### Iteración 4: Usuarios y Auth
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-008 | Como visitante, quiero registrarme para guardar mis datos y pedidos | - Formulario de registro funciona<br>- Validación de email único<br>- Password hasheado<br>- Email de verificación enviado | Alta |
| US-009 | Como usuario, quiero iniciar sesión para acceder a mi cuenta | - Login con email/password<br>- Remember me funciona<br>- Carrito de sesión se asocia a usuario<br>- Redirect post-login correcto | Alta |
| US-010 | Como usuario, quiero gestionar mis direcciones para agilizar el checkout | - CRUD de direcciones<br>- Marcar dirección por defecto<br>- Máximo 5 direcciones<br>- Validación de campos | Media |

### Iteración 5: Checkout y Pedidos
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-011 | Como usuario, quiero completar el checkout para realizar mi compra | - Flujo: Dirección → Resumen → Confirmación<br>- Validación de stock antes de confirmar<br>- Order number generado<br>- Email de confirmación enviado | Alta |
| US-012 | Como usuario, quiero ver mis pedidos anteriores para hacer seguimiento | - Lista de pedidos con estado<br>- Detalle de cada pedido<br>- Filtro por estado<br>- Ordenados por fecha desc | Alta |
| US-013 | Como admin, quiero gestionar pedidos para procesar las ventas | - Lista de todos los pedidos<br>- Cambiar estado del pedido<br>- Ver detalles completos<br>- Filtros por estado/fecha | Alta |

### Iteración 6: Inventario
| ID | Historia de Usuario | Criterios de Aceptación | Prioridad |
|----|---------------------|------------------------|-----------|
| US-014 | Como admin, quiero gestionar el stock para evitar sobreventa | - Ver stock actual por producto<br>- Registrar movimientos (entrada/salida)<br>- Historial de movimientos<br>- Alertas de stock bajo | Media |
| US-015 | Como sistema, quiero descontar stock automáticamente al confirmar pedido | - Stock se reduce al crear orden<br>- Stock se restaura si orden cancelada<br>- Notificación si stock < threshold<br>- Prevenir pedido si stock = 0 | Alta |

## Backlog Nivel B: Post-MVP

| ID | Historia de Usuario | Prioridad |
|----|---------------------|-----------|
| US-016 | Integración con pasarela de pagos (Stripe/PayPal) | Alta |
| US-017 | Sistema de cupones y descuentos | Media |
| US-018 | Wishlist / Lista de deseos | Baja |
| US-019 | Reviews y ratings de productos | Media |
| US-020 | Búsqueda avanzada con Algolia/Meilisearch | Media |
| US-021 | Variantes de producto (talla, color) | Alta |
| US-022 | Múltiples imágenes por producto con galería | Media |
| US-023 | Notificaciones por email transaccionales | Alta |
| US-024 | Dashboard de analytics para admin | Media |
| US-025 | Exportación de pedidos a CSV/Excel | Baja |
| US-026 | Sistema de envíos con tracking | Alta |
| US-027 | Multi-idioma (i18n) | Baja |
| US-028 | PWA / App móvil | Baja |
| US-029 | Integración con ERP externo | Baja |
| US-030 | A/B testing de precios | Baja |

## Orden de Implementación por Iteraciones

```
Semana 1-2: Iteración 1 (Fundamentos)
├── Setup Docker
├── Laravel scaffold
├── Estructura de dominios
└── CI básico

Semana 3-4: Iteración 2 (Catálogo)
├── Models: Product, Category
├── Migrations y seeders
├── Controllers y vistas
└── Tests de catálogo

Semana 5-6: Iteración 3 (Carrito)
├── Models: Cart, CartItem
├── Session handling
├── Actions de carrito
└── Tests de carrito

Semana 7-8: Iteración 4 (Auth)
├── User registration/login
├── Address management
├── Policies y middleware
└── Tests de auth

Semana 9-10: Iteración 5 (Checkout)
├── Order creation flow
├── Payment placeholder
├── Email notifications
└── Tests E2E

Semana 11-12: Iteración 6 (Inventario)
├── Stock management
├── Movement tracking
├── Alerts system
└── Integration tests

Post-MVP: Según prioridad de negocio
```

## Definition of Done Global

Un feature se considera DONE cuando:

1. **Código**
   - [ ] Código escrito siguiendo convenciones del proyecto
   - [ ] Sin errores de PHPStan level 8
   - [ ] Sin warnings de PHP CS Fixer

2. **Tests**
   - [ ] Tests unitarios escritos (cobertura >80%)
   - [ ] Tests feature escritos para endpoints
   - [ ] Todos los tests pasan en CI

3. **Seguridad**
   - [ ] Inputs validados con Form Requests
   - [ ] Authorization con Policies verificada
   - [ ] Sin vulnerabilidades conocidas

4. **Documentación**
   - [ ] PHPDoc en métodos públicos
   - [ ] README actualizado si aplica
   - [ ] API endpoints documentados

5. **Review**
   - [ ] PR aprobado por al menos 1 reviewer
   - [ ] Comentarios de review resueltos
   - [ ] Merge a develop sin conflictos
