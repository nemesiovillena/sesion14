# Comando: /migrate

## Descripción
Workflow para crear y ejecutar migraciones de base de datos de forma segura.

## Uso
```
/migrate [create|run|rollback|fresh] [opciones]
```

## Subcomandos

### /migrate create [nombre]
Crear nueva migración siguiendo convenciones.

### /migrate run
Ejecutar migraciones pendientes.

### /migrate rollback
Revertir última migración.

### /migrate fresh
Fresh migration con seeds (SOLO desarrollo).

## Flujo para Crear Migración

### 1. Análisis (Agente: @database)
- Identificar tablas afectadas
- Definir columnas e índices
- Verificar impacto en datos existentes

### 2. Creación (Agente: @database)
```bash
php artisan make:migration [nombre]
```

### 3. Implementación (Agente: @database)
- Escribir migración up()
- Escribir migración down() (OBLIGATORIO)
- Añadir índices apropiados
- Documentar cambios

### 4. Verificación (Agente: @database)
```bash
# Ejecutar migración
php artisan migrate

# Verificar que down funciona
php artisan migrate:rollback

# Volver a ejecutar
php artisan migrate
```

### 5. Actualizar Factories/Seeders (Agente: @database)
- Actualizar factories si hay nuevas columnas
- Actualizar seeders si es necesario

## Checklist de Migración

- [ ] Nomenclatura correcta (YYYY_MM_DD_HHMMSS_action_table_description)
- [ ] Método up() implementado
- [ ] Método down() implementado (reversible)
- [ ] Índices definidos con justificación
- [ ] Foreign keys con ON DELETE apropiado
- [ ] Factory actualizada
- [ ] Seeder actualizado si aplica
- [ ] Documentación de cambios

## Convenciones de Nomenclatura

```
# Crear tabla
create_products_table

# Añadir columna
add_sku_to_products_table

# Modificar columna
change_price_column_in_products_table

# Añadir índice
add_status_index_to_products_table

# Eliminar columna
remove_legacy_field_from_products_table

# Crear tabla pivot
create_product_tag_table
```

## Ejemplo de Migración

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
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->string('slug')->unique();
            $table->decimal('price', 10, 2);
            $table->string('sku')->unique();
            $table->integer('stock_quantity')->default(0);
            $table->enum('status', ['draft', 'active', 'out_of_stock'])->default('draft');
            $table->timestamps();
            $table->softDeletes();

            $table->index('status');
            $table->index(['status', 'category_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
```

## Migraciones en Producción

### Reglas Críticas
1. **NUNCA** usar `migrate:fresh` en producción
2. **SIEMPRE** hacer backup antes de migrar
3. **SIEMPRE** probar rollback en staging
4. **CONSIDERAR** downtime para cambios en tablas grandes

### Plan de Migración Segura
```
1. Backup de base de datos
2. Ejecutar en staging
3. Verificar rollback en staging
4. Programar ventana de mantenimiento
5. Ejecutar en producción
6. Verificar funcionamiento
7. Si falla → rollback inmediato
```

## Notas

- Escalar a opus si la migración afecta datos de producción
- Usar haiku para migraciones simples de nuevas tablas
- Documentar impacto estimado en tablas grandes
- Siempre crear índices para foreign keys
