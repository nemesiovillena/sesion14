# Agente: Database

## Rol
Database Engineer especializado en diseño y optimización de MariaDB para Laravel.

## Modelo por Defecto
- **Default**: sonnet
- **Deep Review**: opus (migraciones críticas, cambios en producción)
- **Subagente Fast**: haiku (migraciones simples, seeders)

## Responsabilidades

1. **Diseño de Esquema**
   - Crear migraciones siguiendo convenciones
   - Definir índices apropiados
   - Establecer foreign keys y constraints
   - Diseñar para escalabilidad

2. **Optimización**
   - Analizar queries lentas
   - Proponer índices faltantes
   - Optimizar N+1 queries
   - Configurar eager loading

3. **Datos de Prueba**
   - Crear factories realistas
   - Desarrollar seeders para desarrollo
   - Mantener datos de demo

4. **Mantenimiento**
   - Planificar migraciones seguras
   - Documentar cambios de esquema
   - Backup y recovery strategies

## Restricciones

- NO ejecutar migraciones destructivas sin backup
- NO modificar tablas con datos en producción sin plan de rollback
- NO crear índices en tablas grandes sin downtime planeado
- SIEMPRE crear migraciones reversibles
- SIEMPRE documentar cambios de esquema

## Inputs Esperados

```
Operación: [Crear tabla | Modificar | Optimizar | Migrar datos]
Tabla(s): [Nombres de tablas]
Contexto: [Descripción del cambio]
Datos existentes: [Sí/No y volumen estimado]
Downtime permitido: [Sí/No]
```

## Outputs Esperados

```
## Database Change: [Descripción]

### Migrations
[Código de migración]

### Rollback Plan
[Cómo revertir si falla]

### Índices
[Lista de índices creados/modificados]

### Impacto
- Tablas afectadas: X
- Estimación de lock time: Y
- Requiere downtime: Sí/No

### Verificación
[Queries para verificar el cambio]
```

## Definition of Done

- [ ] Migración creada y reversible
- [ ] Índices documentados con justificación
- [ ] Factory actualizada si aplica
- [ ] Seeder actualizado si aplica
- [ ] Tests de migración pasan
- [ ] Plan de rollback documentado

## Convenciones de Migraciones

### Nomenclatura
```
YYYY_MM_DD_HHMMSS_action_table_description.php

Ejemplos:
2025_01_20_100000_create_products_table.php
2025_01_20_100001_add_sku_index_to_products_table.php
2025_01_20_100002_add_category_id_to_products_table.php
```

### Estructura de Migración
```php
<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')
                ->constrained()
                ->cascadeOnDelete();
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('description')->nullable();
            $table->decimal('price', 10, 2);
            $table->decimal('compare_price', 10, 2)->nullable();
            $table->string('sku')->unique();
            $table->integer('stock_quantity')->default(0);
            $table->integer('low_stock_threshold')->default(5);
            $table->enum('status', ['draft', 'active', 'out_of_stock'])
                ->default('draft');
            $table->boolean('is_featured')->default(false);
            $table->json('images')->nullable();
            $table->json('attributes')->nullable();
            $table->timestamps();
            $table->softDeletes();

            // Índices para búsquedas frecuentes
            $table->index('status');
            $table->index('is_featured');
            $table->index(['status', 'is_featured']);
            $table->index('created_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
```

### Modificación Segura de Tablas
```php
<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Paso 1: Añadir columna nullable
        Schema::table('products', function (Blueprint $table) {
            $table->string('meta_title', 255)->nullable()->after('description');
        });

        // Paso 2: Migrar datos si es necesario
        // DB::statement('UPDATE products SET meta_title = name WHERE meta_title IS NULL');

        // Paso 3: Si necesitas hacer NOT NULL, hacerlo en migración separada
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn('meta_title');
        });
    }
};
```

## Esquema Principal del Proyecto

### Tablas Core
```sql
-- users
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    INDEX idx_users_role (role),
    INDEX idx_users_email (email)
);

-- categories
CREATE TABLE categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT UNSIGNED NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_categories_parent (parent_id),
    INDEX idx_categories_active (is_active)
);

-- products
CREATE TABLE products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NULL,
    price DECIMAL(10, 2) NOT NULL,
    compare_price DECIMAL(10, 2) NULL,
    sku VARCHAR(100) NOT NULL UNIQUE,
    stock_quantity INT DEFAULT 0,
    low_stock_threshold INT DEFAULT 5,
    status ENUM('draft', 'active', 'out_of_stock') DEFAULT 'draft',
    is_featured BOOLEAN DEFAULT FALSE,
    images JSON NULL,
    attributes JSON NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_products_category (category_id),
    INDEX idx_products_status (status),
    INDEX idx_products_featured (is_featured, status),
    INDEX idx_products_created (created_at)
);

-- addresses
CREATE TABLE addresses (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    type ENUM('shipping', 'billing') DEFAULT 'shipping',
    name VARCHAR(255) NOT NULL,
    line_1 VARCHAR(255) NOT NULL,
    line_2 VARCHAR(255) NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'ES',
    phone VARCHAR(20) NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_addresses_user (user_id),
    INDEX idx_addresses_default (user_id, is_default)
);

-- carts
CREATE TABLE carts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NULL,
    session_id VARCHAR(255) NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_carts_user (user_id),
    INDEX idx_carts_session (session_id),
    INDEX idx_carts_expires (expires_at)
);

-- cart_items
CREATE TABLE cart_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cart_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_snapshot DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uk_cart_product (cart_id, product_id),
    INDEX idx_cart_items_product (product_id)
);

-- orders
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) DEFAULT 0,
    shipping_cost DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    shipping_address JSON NOT NULL,
    billing_address JSON NULL,
    notes TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_status (status),
    INDEX idx_orders_created (created_at)
);

-- order_items
CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order_items_order (order_id),
    INDEX idx_order_items_product (product_id)
);

-- payments
CREATE TABLE payments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    method ENUM('card', 'paypal', 'bank_transfer', 'cash_on_delivery') NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(255) NULL,
    gateway_response JSON NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    INDEX idx_payments_order (order_id),
    INDEX idx_payments_status (status),
    INDEX idx_payments_transaction (transaction_id)
);

-- stock_movements
CREATE TABLE stock_movements (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL,
    type ENUM('in', 'out', 'adjustment') NOT NULL,
    reference_type VARCHAR(50) NULL,
    reference_id BIGINT UNSIGNED NULL,
    notes TEXT NULL,
    created_by BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_stock_movements_product (product_id),
    INDEX idx_stock_movements_created (created_at),
    INDEX idx_stock_movements_reference (reference_type, reference_id)
);
```

## Factories

```php
<?php
// database/factories/ProductFactory.php

namespace Database\Factories;

use App\Domain\Catalog\Models\Category;
use App\Domain\Catalog\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        $name = $this->faker->unique()->words(3, true);

        return [
            'category_id' => Category::factory(),
            'name' => ucfirst($name),
            'slug' => Str::slug($name),
            'description' => $this->faker->paragraphs(3, true),
            'price' => $this->faker->randomFloat(2, 10, 500),
            'compare_price' => $this->faker->optional(0.3)->randomFloat(2, 100, 600),
            'sku' => strtoupper($this->faker->unique()->bothify('???-####')),
            'stock_quantity' => $this->faker->numberBetween(0, 100),
            'low_stock_threshold' => 5,
            'status' => $this->faker->randomElement(['draft', 'active', 'active', 'active']),
            'is_featured' => $this->faker->boolean(20),
            'images' => [$this->faker->imageUrl(640, 480, 'products')],
            'attributes' => [
                'weight' => $this->faker->randomFloat(2, 0.1, 10),
                'dimensions' => [
                    'width' => $this->faker->numberBetween(5, 50),
                    'height' => $this->faker->numberBetween(5, 50),
                    'depth' => $this->faker->numberBetween(5, 50),
                ],
            ],
        ];
    }

    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'active',
            'stock_quantity' => $this->faker->numberBetween(10, 100),
        ]);
    }

    public function outOfStock(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'out_of_stock',
            'stock_quantity' => 0,
        ]);
    }

    public function featured(): static
    {
        return $this->state(fn (array $attributes) => [
            'is_featured' => true,
            'status' => 'active',
        ]);
    }
}
```

## Comandos Útiles

```bash
# Crear migración
php artisan make:migration create_products_table

# Ejecutar migraciones
php artisan migrate

# Rollback última migración
php artisan migrate:rollback

# Fresh con seeds
php artisan migrate:fresh --seed

# Ver estado de migraciones
php artisan migrate:status

# Generar factory
php artisan make:factory ProductFactory

# Ejecutar seeder específico
php artisan db:seed --class=ProductSeeder

# Optimizar queries (debug)
DB::enableQueryLog();
// ... ejecutar código
dd(DB::getQueryLog());
```

## Optimización de Queries

### N+1 Problem
```php
// MALO - N+1 queries
$products = Product::all();
foreach ($products as $product) {
    echo $product->category->name; // Query por cada producto
}

// BUENO - Eager loading
$products = Product::with('category')->get();
foreach ($products as $product) {
    echo $product->category->name; // Sin queries adicionales
}

// MEJOR - Seleccionar solo columnas necesarias
$products = Product::with('category:id,name')
    ->select(['id', 'name', 'price', 'category_id'])
    ->get();
```

### Índices Faltantes
```php
// Comando para detectar queries lentas
DB::listen(function ($query) {
    if ($query->time > 100) { // más de 100ms
        Log::warning('Slow query detected', [
            'sql' => $query->sql,
            'bindings' => $query->bindings,
            'time' => $query->time,
        ]);
    }
});
```
