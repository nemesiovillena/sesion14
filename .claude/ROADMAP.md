# Products&Inventory - Roadmap de Desarrollo

## Visión General

| Aspecto | Detalle |
|---------|---------|
| **Proyecto** | Products&Inventory - Ecommerce Laravel 12 |
| **Duración Total** | 12 Sprints (24 semanas) |
| **Duración Sprint** | 2 semanas |
| **Metodología** | Scrum adaptado |
| **Deploy Target** | Easypanel (VPS) |

---

## Fases del Proyecto

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ROADMAP GENERAL                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  FASE 1: FUNDAMENTOS          FASE 2: CORE              FASE 3: CHECKOUT   │
│  ══════════════════           ════════════              ════════════════   │
│  Sprint 1-2                   Sprint 3-5                Sprint 6-7          │
│  • Setup proyecto             • Catálogo                • Carrito           │
│  • Docker/CI                  • Usuarios                • Checkout          │
│  • Arquitectura               • Admin básico            • Pedidos           │
│                                                                             │
│  FASE 4: PAGOS               FASE 5: PRODUCCIÓN        FASE 6: MEJORAS     │
│  ════════════                ══════════════════        ═══════════════     │
│  Sprint 8-9                  Sprint 10-11              Sprint 12            │
│  • Pasarela pagos            • Deploy Easypanel        • Optimización      │
│  • Inventario                • Monitorización          • Features extra    │
│  • Notificaciones            • Seguridad prod          • Documentación     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

# FASE 1: FUNDAMENTOS (Sprints 1-2)

## Sprint 1: Setup y Arquitectura Base

**Objetivo**: Proyecto Laravel 12 funcionando con Docker y CI básico.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S1-01 | Crear proyecto Laravel 12 con Composer | @devops | Alta | ✅ Completado |
| S1-02 | Configurar Docker (PHP 8.4, MariaDB, Redis, Nginx) | @devops | Alta | ✅ Completado |
| S1-03 | Configurar .env y variables de entorno | @devops | Alta | ✅ Completado |
| S1-04 | Instalar y configurar dependencias base | @developer | Alta | ✅ Completado |
| S1-05 | Crear estructura de directorios (Domain/, Actions/, Services/) | @architect | Alta | ✅ Completado |
| S1-06 | Configurar PHPStan level 8 | @developer | Media | ✅ Completado |
| S1-07 | Configurar Laravel Pint (code style) | @developer | Media | ✅ Completado |
| S1-08 | Configurar Pest PHP para testing | @tester | Media | ✅ Completado |
| S1-09 | Crear pipeline CI básico (GitHub Actions) | @devops | Media | ✅ Completado |
| S1-10 | Documentar setup en README | @developer | Baja | ✅ Completado |

### Entregables
- [x] Proyecto Laravel 12 corriendo en Docker
- [x] Makefile con comandos básicos funcionando
- [x] CI ejecutando tests, lint y análisis estático
- [x] README con instrucciones de instalación

### Definition of Done Sprint 1
- [x] `make install` completa sin errores
- [x] `make test` ejecuta tests base de Laravel
- [x] `make lint` y `make analyze` pasan
- [x] CI en GitHub Actions verde

---

## Sprint 2: Modelos Base y Migraciones

**Objetivo**: Esquema de base de datos completo y modelos Eloquent configurados.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S2-01 | Crear migración tabla `users` (extender default) | @database | Alta | ⬜ Pendiente |
| S2-02 | Crear migración tabla `categories` | @database | Alta | ⬜ Pendiente |
| S2-03 | Crear migración tabla `products` | @database | Alta | ⬜ Pendiente |
| S2-04 | Crear migración tabla `addresses` | @database | Alta | ⬜ Pendiente |
| S2-05 | Crear migración tablas `carts` y `cart_items` | @database | Alta | ⬜ Pendiente |
| S2-06 | Crear migración tablas `orders` y `order_items` | @database | Alta | ⬜ Pendiente |
| S2-07 | Crear migración tabla `payments` | @database | Alta | ⬜ Pendiente |
| S2-08 | Crear migración tabla `stock_movements` | @database | Media | ⬜ Pendiente |
| S2-09 | Crear Models con relaciones (User, Category, Product) | @developer | Alta | ⬜ Pendiente |
| S2-10 | Crear Models con relaciones (Cart, Order, Payment) | @developer | Alta | ⬜ Pendiente |
| S2-11 | Crear Enums (UserRole, OrderStatus, PaymentStatus, ProductStatus) | @developer | Media | ⬜ Pendiente |
| S2-12 | Crear Factories para todos los modelos | @tester | Media | ⬜ Pendiente |
| S2-13 | Crear Seeders básicos (categorías, productos demo) | @database | Media | ⬜ Pendiente |
| S2-14 | Tests unitarios de modelos y relaciones | @tester | Media | ⬜ Pendiente |

### Entregables
- [ ] Todas las migraciones creadas y ejecutables
- [ ] Modelos Eloquent con relaciones definidas
- [ ] Factories y Seeders funcionando
- [ ] Tests de modelos pasando

### Definition of Done Sprint 2
- [ ] `make migrate-fresh` ejecuta sin errores
- [ ] Todas las relaciones de modelos testeadas
- [ ] Cobertura de modelos >80%
- [ ] Seeders crean datos de demo realistas

---

# FASE 2: FUNCIONALIDADES CORE (Sprints 3-5)

## Sprint 3: Catálogo de Productos

**Objetivo**: Listado y detalle de productos funcionando (web + API).

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S3-01 | Crear layout principal `app.blade.php` | @frontend | Alta | ⬜ Pendiente |
| S3-02 | Crear componentes UI base (button, input, card, badge) | @frontend | Alta | ⬜ Pendiente |
| S3-03 | Crear CatalogController (index, show) | @developer | Alta | ⬜ Pendiente |
| S3-04 | Crear vista listado de productos `/catalog` | @frontend | Alta | ⬜ Pendiente |
| S3-05 | Crear componente `product-card.blade.php` | @frontend | Alta | ⬜ Pendiente |
| S3-06 | Crear vista detalle de producto `/catalog/{slug}` | @frontend | Alta | ⬜ Pendiente |
| S3-07 | Implementar filtro por categoría | @developer | Media | ⬜ Pendiente |
| S3-08 | Implementar ordenación (precio, nombre, fecha) | @developer | Media | ⬜ Pendiente |
| S3-09 | Implementar paginación | @developer | Media | ⬜ Pendiente |
| S3-10 | Crear API endpoints (GET /api/v1/products, GET /api/v1/products/{id}) | @developer | Media | ⬜ Pendiente |
| S3-11 | Crear ProductResource para API | @developer | Media | ⬜ Pendiente |
| S3-12 | Tests feature de catálogo | @tester | Media | ⬜ Pendiente |
| S3-13 | Optimizar queries (eager loading categorías) | @database | Baja | ⬜ Pendiente |

### Entregables
- [ ] Página de catálogo con productos paginados
- [ ] Página de detalle de producto
- [ ] Filtros y ordenación funcionando
- [ ] API de productos documentada

### Definition of Done Sprint 3
- [ ] Catálogo muestra productos activos
- [ ] Filtro por categoría funciona
- [ ] Detalle de producto muestra toda la información
- [ ] API devuelve JSON correctamente
- [ ] Tests feature del catálogo pasan

---

## Sprint 4: Autenticación y Usuarios

**Objetivo**: Sistema de registro, login y gestión de cuenta de usuario.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S4-01 | Instalar Laravel Breeze o Fortify | @developer | Alta | ⬜ Pendiente |
| S4-02 | Personalizar vistas de auth (login, register) | @frontend | Alta | ⬜ Pendiente |
| S4-03 | Implementar RegisterUserAction | @developer | Alta | ⬜ Pendiente |
| S4-04 | Configurar verificación de email | @developer | Alta | ⬜ Pendiente |
| S4-05 | Crear layout `auth.blade.php` | @frontend | Media | ⬜ Pendiente |
| S4-06 | Implementar página de cuenta `/account` | @frontend | Media | ⬜ Pendiente |
| S4-07 | Implementar UpdateProfileAction | @developer | Media | ⬜ Pendiente |
| S4-08 | Crear CRUD de direcciones `/account/addresses` | @developer | Media | ⬜ Pendiente |
| S4-09 | Crear AddressController y vistas | @frontend | Media | ⬜ Pendiente |
| S4-10 | Configurar Sanctum para API auth | @developer | Media | ⬜ Pendiente |
| S4-11 | Crear API endpoints de auth (login, register, logout) | @developer | Media | ⬜ Pendiente |
| S4-12 | Implementar middleware EnsureEmailVerified | @developer | Baja | ⬜ Pendiente |
| S4-13 | Tests feature de autenticación | @tester | Alta | ⬜ Pendiente |
| S4-14 | Auditoría de seguridad de auth | @security | Alta | ⬜ Pendiente |

### Entregables
- [ ] Registro y login funcionando
- [ ] Verificación de email activa
- [ ] Página de cuenta con edición de perfil
- [ ] CRUD de direcciones completo
- [ ] API auth con Sanctum

### Definition of Done Sprint 4
- [ ] Usuario puede registrarse y verificar email
- [ ] Usuario puede loguearse y cerrar sesión
- [ ] Usuario puede editar perfil y direcciones
- [ ] Rate limiting en login activo
- [ ] Tests de auth con cobertura >90%

---

## Sprint 5: Panel de Administración

**Objetivo**: Dashboard admin con gestión de productos, categorías y usuarios.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S5-01 | Crear layout `admin.blade.php` | @frontend | Alta | ⬜ Pendiente |
| S5-02 | Crear componentes admin (sidebar, header, data-table) | @frontend | Alta | ⬜ Pendiente |
| S5-03 | Implementar middleware EnsureUserIsAdmin | @developer | Alta | ⬜ Pendiente |
| S5-04 | Crear AdminDashboardController | @developer | Alta | ⬜ Pendiente |
| S5-05 | Crear dashboard con estadísticas básicas | @frontend | Alta | ⬜ Pendiente |
| S5-06 | CRUD de productos (Admin\ProductController) | @developer | Alta | ⬜ Pendiente |
| S5-07 | Vistas admin de productos (index, create, edit) | @frontend | Alta | ⬜ Pendiente |
| S5-08 | Implementar subida de imágenes de productos | @developer | Media | ⬜ Pendiente |
| S5-09 | CRUD de categorías (Admin\CategoryController) | @developer | Media | ⬜ Pendiente |
| S5-10 | Vistas admin de categorías | @frontend | Media | ⬜ Pendiente |
| S5-11 | Listado de usuarios (Admin\UserController) | @developer | Media | ⬜ Pendiente |
| S5-12 | Crear ProductPolicy y CategoryPolicy | @developer | Media | ⬜ Pendiente |
| S5-13 | Tests feature del panel admin | @tester | Media | ⬜ Pendiente |
| S5-14 | Auditoría de autorización admin | @security | Alta | ⬜ Pendiente |

### Entregables
- [ ] Dashboard admin con métricas
- [ ] CRUD completo de productos con imágenes
- [ ] CRUD de categorías
- [ ] Listado de usuarios
- [ ] Políticas de autorización

### Definition of Done Sprint 5
- [ ] Solo admins acceden a `/admin/*`
- [ ] CRUD de productos funcional con validación
- [ ] Imágenes se suben y muestran correctamente
- [ ] Dashboard muestra estadísticas reales
- [ ] Tests admin con cobertura >80%

---

# FASE 3: CHECKOUT (Sprints 6-7)

## Sprint 6: Carrito de Compras

**Objetivo**: Carrito funcional con persistencia en sesión y base de datos.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S6-01 | Crear CartService para gestión de carrito | @developer | Alta | ⬜ Pendiente |
| S6-02 | Implementar AddToCartAction | @developer | Alta | ⬜ Pendiente |
| S6-03 | Implementar UpdateCartItemAction | @developer | Alta | ⬜ Pendiente |
| S6-04 | Implementar RemoveFromCartAction | @developer | Alta | ⬜ Pendiente |
| S6-05 | Crear CartController (web) | @developer | Alta | ⬜ Pendiente |
| S6-06 | Crear vista de carrito `/cart` | @frontend | Alta | ⬜ Pendiente |
| S6-07 | Crear componentes carrito (cart-item, cart-summary, quantity-selector) | @frontend | Alta | ⬜ Pendiente |
| S6-08 | Implementar carrito en header (mini-cart icon) | @frontend | Media | ⬜ Pendiente |
| S6-09 | Middleware EnsureCartExists | @developer | Media | ⬜ Pendiente |
| S6-10 | Migrar carrito de sesión a usuario al login | @developer | Media | ⬜ Pendiente |
| S6-11 | Validar stock disponible al añadir | @developer | Alta | ⬜ Pendiente |
| S6-12 | API endpoints de carrito | @developer | Media | ⬜ Pendiente |
| S6-13 | Tests feature de carrito | @tester | Alta | ⬜ Pendiente |
| S6-14 | Tests E2E de flujo de carrito | @tester | Media | ⬜ Pendiente |

### Entregables
- [ ] Añadir productos al carrito
- [ ] Modificar cantidades
- [ ] Eliminar productos
- [ ] Carrito persistente entre sesiones
- [ ] Validación de stock

### Definition of Done Sprint 6
- [ ] Usuario puede añadir/quitar productos del carrito
- [ ] Carrito se mantiene al cerrar navegador
- [ ] Carrito de sesión se une a cuenta al login
- [ ] No permite añadir más stock del disponible
- [ ] Tests de carrito con cobertura >85%

---

## Sprint 7: Proceso de Checkout y Pedidos

**Objetivo**: Flujo completo de checkout y gestión de pedidos.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S7-01 | Crear CheckoutController | @developer | Alta | ⬜ Pendiente |
| S7-02 | Implementar CreateOrderAction | @developer | Alta | ⬜ Pendiente |
| S7-03 | Crear CreateOrderRequest con validaciones | @developer | Alta | ⬜ Pendiente |
| S7-04 | Crear vista de checkout `/checkout` | @frontend | Alta | ⬜ Pendiente |
| S7-05 | Implementar selección de dirección de envío | @frontend | Alta | ⬜ Pendiente |
| S7-06 | Crear página de confirmación de pedido | @frontend | Alta | ⬜ Pendiente |
| S7-07 | Generar order_number único | @developer | Media | ⬜ Pendiente |
| S7-08 | Crear OrderPolicy | @developer | Media | ⬜ Pendiente |
| S7-09 | Crear AccountOrderController (historial) | @developer | Media | ⬜ Pendiente |
| S7-10 | Vista de historial de pedidos `/account/orders` | @frontend | Media | ⬜ Pendiente |
| S7-11 | Vista de detalle de pedido `/account/orders/{id}` | @frontend | Media | ⬜ Pendiente |
| S7-12 | Evento OrderCreated + Listener para email | @developer | Media | ⬜ Pendiente |
| S7-13 | Email de confirmación de pedido | @frontend | Media | ⬜ Pendiente |
| S7-14 | Reducir stock al crear pedido | @developer | Alta | ⬜ Pendiente |
| S7-15 | Gestión de pedidos en admin | @developer | Media | ⬜ Pendiente |
| S7-16 | Tests E2E de checkout completo | @tester | Alta | ⬜ Pendiente |

### Entregables
- [ ] Flujo de checkout completo
- [ ] Creación de pedidos con validación de stock
- [ ] Historial de pedidos del usuario
- [ ] Email de confirmación
- [ ] Gestión de pedidos en admin

### Definition of Done Sprint 7
- [ ] Usuario puede completar checkout
- [ ] Pedido se crea con todos los datos
- [ ] Stock se reduce automáticamente
- [ ] Email de confirmación se envía
- [ ] Admin puede ver y cambiar estado de pedidos
- [ ] Tests E2E de checkout pasan

---

# FASE 4: PAGOS E INVENTARIO (Sprints 8-9)

## Sprint 8: Integración de Pagos

**Objetivo**: Pasarela de pagos integrada (Stripe o similar).

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S8-01 | Investigar y seleccionar pasarela (Stripe/Redsys) | @architect | Alta | ⬜ Pendiente |
| S8-02 | Instalar SDK de pasarela de pagos | @developer | Alta | ⬜ Pendiente |
| S8-03 | Crear PaymentService | @developer | Alta | ⬜ Pendiente |
| S8-04 | Implementar ProcessPaymentAction | @developer | Alta | ⬜ Pendiente |
| S8-05 | Integrar formulario de pago en checkout | @frontend | Alta | ⬜ Pendiente |
| S8-06 | Implementar webhook de confirmación de pago | @developer | Alta | ⬜ Pendiente |
| S8-07 | Crear ProcessPaymentJob (async) | @developer | Media | ⬜ Pendiente |
| S8-08 | Manejar estados de pago (pending, completed, failed) | @developer | Alta | ⬜ Pendiente |
| S8-09 | Página de pago exitoso/fallido | @frontend | Media | ⬜ Pendiente |
| S8-10 | Logging de transacciones (canal payments) | @developer | Media | ⬜ Pendiente |
| S8-11 | Tests con mock de pasarela | @tester | Alta | ⬜ Pendiente |
| S8-12 | Auditoría de seguridad de pagos | @security | Alta | ⬜ Pendiente |
| S8-13 | Documentar flujo de pagos | @developer | Media | ⬜ Pendiente |

### Entregables
- [ ] Pasarela de pagos integrada
- [ ] Webhooks procesando confirmaciones
- [ ] Logging completo de transacciones
- [ ] Manejo de errores de pago

### Definition of Done Sprint 8
- [ ] Pago con tarjeta funciona en sandbox
- [ ] Webhook actualiza estado de pedido
- [ ] Logs de pago en canal separado
- [ ] Tests con mocks de pasarela pasan
- [ ] Auditoría de seguridad aprobada

---

## Sprint 9: Gestión de Inventario

**Objetivo**: Control de stock con movimientos y alertas.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S9-01 | Crear InventoryService | @developer | Alta | ⬜ Pendiente |
| S9-02 | Implementar UpdateStockAction | @developer | Alta | ⬜ Pendiente |
| S9-03 | Registrar StockMovement en cada cambio | @developer | Alta | ⬜ Pendiente |
| S9-04 | Crear Admin\InventoryController | @developer | Alta | ⬜ Pendiente |
| S9-05 | Vista de gestión de inventario en admin | @frontend | Alta | ⬜ Pendiente |
| S9-06 | Historial de movimientos por producto | @frontend | Media | ⬜ Pendiente |
| S9-07 | Evento StockLow + Listener para notificación | @developer | Media | ⬜ Pendiente |
| S9-08 | Email de alerta de stock bajo | @frontend | Media | ⬜ Pendiente |
| S9-09 | Dashboard widget de productos con stock bajo | @frontend | Media | ⬜ Pendiente |
| S9-10 | Restaurar stock si pedido cancelado | @developer | Media | ⬜ Pendiente |
| S9-11 | Prevenir checkout si stock insuficiente | @developer | Alta | ⬜ Pendiente |
| S9-12 | Tests de inventario | @tester | Alta | ⬜ Pendiente |

### Entregables
- [ ] Gestión de stock desde admin
- [ ] Historial de movimientos
- [ ] Alertas de stock bajo
- [ ] Integración con checkout y cancelaciones

### Definition of Done Sprint 9
- [ ] Stock se actualiza correctamente en todas las operaciones
- [ ] Movimientos se registran con trazabilidad
- [ ] Alertas se envían cuando stock < threshold
- [ ] Checkout falla si no hay stock suficiente
- [ ] Tests de inventario con cobertura >85%

---

# FASE 5: PRODUCCIÓN (Sprints 10-11)

## Sprint 10: Preparación para Producción

**Objetivo**: Aplicación lista para deploy con optimizaciones y seguridad.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S10-01 | Auditoría completa de seguridad | @security | Alta | ⬜ Pendiente |
| S10-02 | Implementar headers de seguridad | @security | Alta | ⬜ Pendiente |
| S10-03 | Configurar CSP (Content Security Policy) | @security | Alta | ⬜ Pendiente |
| S10-04 | Revisar y corregir vulnerabilidades | @security | Alta | ⬜ Pendiente |
| S10-05 | Optimizar queries (analizar slow queries) | @database | Alta | ⬜ Pendiente |
| S10-06 | Configurar cache de config/routes/views | @devops | Media | ⬜ Pendiente |
| S10-07 | Optimizar assets (minificación, compresión) | @frontend | Media | ⬜ Pendiente |
| S10-08 | Configurar queue workers para producción | @devops | Media | ⬜ Pendiente |
| S10-09 | Crear Dockerfile optimizado para producción | @devops | Alta | ⬜ Pendiente |
| S10-10 | Configurar logging para producción | @devops | Media | ⬜ Pendiente |
| S10-11 | Implementar health check endpoint | @developer | Media | ⬜ Pendiente |
| S10-12 | Crear script de backup de base de datos | @devops | Media | ⬜ Pendiente |
| S10-13 | Documentar variables de entorno de producción | @devops | Media | ⬜ Pendiente |
| S10-14 | Tests de carga básicos | @tester | Baja | ⬜ Pendiente |

### Entregables
- [ ] Aplicación sin vulnerabilidades conocidas
- [ ] Performance optimizada
- [ ] Dockerfile de producción
- [ ] Documentación de deploy

### Definition of Done Sprint 10
- [ ] Auditoría de seguridad sin issues críticos
- [ ] Tiempo de carga <2s en páginas principales
- [ ] Health check endpoint funcionando
- [ ] Todos los tests pasan
- [ ] Documentación de producción completa

---

## Sprint 11: Deploy en Easypanel

**Objetivo**: Aplicación desplegada y funcionando en Easypanel.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S11-01 | Configurar proyecto en Easypanel | @devops | Alta | ⬜ Pendiente |
| S11-02 | Configurar servicio PHP/Laravel | @devops | Alta | ⬜ Pendiente |
| S11-03 | Configurar servicio MariaDB | @devops | Alta | ⬜ Pendiente |
| S11-04 | Configurar servicio Redis | @devops | Alta | ⬜ Pendiente |
| S11-05 | Configurar dominio y SSL | @devops | Alta | ⬜ Pendiente |
| S11-06 | Configurar variables de entorno en Easypanel | @devops | Alta | ⬜ Pendiente |
| S11-07 | Configurar volúmenes persistentes | @devops | Alta | ⬜ Pendiente |
| S11-08 | Ejecutar migraciones en producción | @database | Alta | ⬜ Pendiente |
| S11-09 | Configurar backups automáticos | @devops | Alta | ⬜ Pendiente |
| S11-10 | Configurar worker de queues | @devops | Media | ⬜ Pendiente |
| S11-11 | Configurar scheduler (cron) | @devops | Media | ⬜ Pendiente |
| S11-12 | Verificar emails en producción | @developer | Media | ⬜ Pendiente |
| S11-13 | Verificar pagos en modo live | @developer | Alta | ⬜ Pendiente |
| S11-14 | Smoke tests en producción | @tester | Alta | ⬜ Pendiente |
| S11-15 | Configurar monitorización básica | @devops | Media | ⬜ Pendiente |
| S11-16 | Documentar proceso de deploy | @devops | Media | ⬜ Pendiente |

### Entregables
- [ ] Aplicación live en dominio configurado
- [ ] SSL activo
- [ ] Backups automáticos funcionando
- [ ] Pagos en modo live verificados
- [ ] Monitorización activa

### Definition of Done Sprint 11
- [ ] Sitio accesible via HTTPS
- [ ] Todas las funcionalidades operativas
- [ ] Pagos procesándose correctamente
- [ ] Backups ejecutándose diariamente
- [ ] Alertas de monitorización configuradas

---

# FASE 6: MEJORAS (Sprint 12)

## Sprint 12: Optimización y Features Extra

**Objetivo**: Pulir la aplicación y añadir features post-MVP prioritarias.

**Duración**: 2 semanas

### Tareas

| ID | Tarea | Agente | Prioridad | Estado |
|----|-------|--------|-----------|--------|
| S12-01 | Analizar feedback de usuarios iniciales | @architect | Alta | ⬜ Pendiente |
| S12-02 | Corregir bugs reportados | @developer | Alta | ⬜ Pendiente |
| S12-03 | Optimizar UX según feedback | @frontend | Alta | ⬜ Pendiente |
| S12-04 | Implementar búsqueda de productos | @developer | Media | ⬜ Pendiente |
| S12-05 | Mejorar SEO (meta tags, sitemap) | @frontend | Media | ⬜ Pendiente |
| S12-06 | Añadir analytics (Google Analytics/Plausible) | @frontend | Media | ⬜ Pendiente |
| S12-07 | Crear página de términos y privacidad | @frontend | Media | ⬜ Pendiente |
| S12-08 | Implementar exportación de pedidos CSV | @developer | Baja | ⬜ Pendiente |
| S12-09 | Mejorar dashboard admin con más métricas | @frontend | Baja | ⬜ Pendiente |
| S12-10 | Documentación final del proyecto | @developer | Media | ⬜ Pendiente |
| S12-11 | Preparar plan de features post-launch | @architect | Media | ⬜ Pendiente |

### Entregables
- [ ] Bugs corregidos
- [ ] UX mejorada
- [ ] SEO básico implementado
- [ ] Documentación completa

### Definition of Done Sprint 12
- [ ] Sin bugs críticos conocidos
- [ ] Feedback inicial incorporado
- [ ] SEO básico funcionando
- [ ] Proyecto documentado
- [ ] Plan de siguiente fase definido

---

# Configuración de Easypanel

## Arquitectura en Easypanel

```
┌─────────────────────────────────────────────────────────────┐
│                      EASYPANEL                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐  ┌─────────────────┐                  │
│  │   Laravel App   │  │     Nginx       │                  │
│  │   (PHP 8.4)     │◄─│   (Reverse      │◄── HTTPS        │
│  │                 │  │    Proxy)       │                  │
│  └────────┬────────┘  └─────────────────┘                  │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐  ┌─────────────────┐                  │
│  │    MariaDB      │  │     Redis       │                  │
│  │    (Database)   │  │  (Cache/Queue)  │                  │
│  │                 │  │                 │                  │
│  └─────────────────┘  └─────────────────┘                  │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                       │
│  │   Volumes       │                                       │
│  │  - db_data      │                                       │
│  │  - storage      │                                       │
│  │  - backups      │                                       │
│  └─────────────────┘                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Configuración de Servicios

### Servicio: Laravel App
```yaml
name: products-inventory-app
type: app
source:
  type: github
  repo: tu-usuario/products-inventory
  branch: main
build:
  type: dockerfile
  dockerfile: docker/php/Dockerfile.prod
domains:
  - host: tudominio.com
env:
  - APP_ENV=production
  - APP_DEBUG=false
  - APP_URL=https://tudominio.com
  - DB_HOST=products-inventory-db
  - REDIS_HOST=products-inventory-redis
  # ... más variables
mounts:
  - type: volume
    name: storage
    mountPath: /var/www/storage
```

### Servicio: MariaDB
```yaml
name: products-inventory-db
type: mariadb
version: "10.11"
env:
  - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
  - MYSQL_DATABASE=products_inventory
  - MYSQL_USER=laravel
  - MYSQL_PASSWORD=${DB_PASSWORD}
mounts:
  - type: volume
    name: db_data
    mountPath: /var/lib/mysql
```

### Servicio: Redis
```yaml
name: products-inventory-redis
type: redis
version: "alpine"
mounts:
  - type: volume
    name: redis_data
    mountPath: /data
```

## Variables de Entorno Producción

```bash
# Application
APP_NAME="Products&Inventory"
APP_ENV=production
APP_KEY=base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
APP_DEBUG=false
APP_URL=https://tudominio.com

# Database
DB_CONNECTION=mysql
DB_HOST=products-inventory-db
DB_PORT=3306
DB_DATABASE=products_inventory
DB_USERNAME=laravel
DB_PASSWORD=CONTRASEÑA_SEGURA

# Redis
REDIS_HOST=products-inventory-redis
REDIS_PASSWORD=null
REDIS_PORT=6379

# Cache & Session
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Mail (Producción)
MAIL_MAILER=smtp
MAIL_HOST=smtp.tuproveedor.com
MAIL_PORT=587
MAIL_USERNAME=tu@email.com
MAIL_PASSWORD=CONTRASEÑA_EMAIL
MAIL_ENCRYPTION=tls

# Payments (Producción)
STRIPE_KEY=pk_live_xxxx
STRIPE_SECRET=sk_live_xxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxx

# Logging
LOG_CHANNEL=stack
LOG_LEVEL=warning
```

---

# Checklist de Lanzamiento

## Pre-Launch (1 semana antes)

- [ ] Todos los tests pasan
- [ ] Auditoría de seguridad completada
- [ ] Performance verificada
- [ ] Backups configurados y probados
- [ ] SSL configurado
- [ ] Dominio apuntando correctamente
- [ ] Variables de entorno de producción configuradas
- [ ] Pasarela de pagos en modo live
- [ ] Emails de producción verificados

## Launch Day

- [ ] Deploy final ejecutado
- [ ] Migraciones ejecutadas en producción
- [ ] Smoke tests pasando
- [ ] Monitorización activa
- [ ] Equipo de soporte disponible

## Post-Launch (1 semana después)

- [ ] Monitorizar errores y logs
- [ ] Revisar métricas de performance
- [ ] Recopilar feedback de usuarios
- [ ] Corregir bugs críticos inmediatamente
- [ ] Planificar mejoras para Sprint 12

---

# Métricas de Éxito

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| Uptime | >99.5% | Monitorización |
| Tiempo de carga | <2s | Lighthouse |
| Cobertura de tests | >80% | CI/CD |
| Bugs críticos | 0 | Issue tracker |
| Conversión checkout | >2% | Analytics |
| Satisfacción usuario | >4/5 | Feedback |
