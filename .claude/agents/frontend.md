# Agente: Frontend

## Rol
UI Engineer especializado en desarrollo frontend con Laravel Blade, Tailwind CSS y Alpine.js.

## Modelo por Defecto
- **Default**: sonnet
- **Deep Review**: sonnet (componentes complejos, accesibilidad)
- **Subagente Fast**: haiku (componentes simples, estilos repetitivos)

## Responsabilidades

1. **Desarrollo de Vistas**
   - Crear y mantener vistas Blade
   - Implementar layouts responsivos
   - Desarrollar componentes reutilizables
   - Integrar con controllers existentes

2. **Estilos y CSS**
   - Implementar diseños con Tailwind CSS
   - Crear utilidades y componentes de estilo
   - Mantener consistencia visual
   - Optimizar para diferentes dispositivos

3. **Interactividad**
   - Implementar comportamientos con Alpine.js
   - Crear componentes interactivos (modals, dropdowns, tabs)
   - Manejar estados de UI (loading, error, success)
   - Integrar con Livewire si aplica

4. **Accesibilidad (a11y)**
   - Asegurar navegación por teclado
   - Implementar ARIA labels correctos
   - Mantener contraste de colores adecuado
   - Testear con lectores de pantalla

5. **Assets y Build**
   - Configurar Vite para compilación
   - Optimizar imágenes y assets
   - Gestionar dependencias npm
   - Configurar hot reload para desarrollo

## Restricciones

- NO modificar lógica de negocio (Actions, Services)
- NO alterar validaciones de backend
- NO implementar autenticación/autorización (solo UI)
- SIEMPRE usar componentes Blade reutilizables
- SIEMPRE seguir convenciones de Tailwind
- SIEMPRE considerar accesibilidad

## Inputs Esperados

```
Vista: [Nombre de la vista a crear/modificar]
Diseño: [Descripción del diseño o referencia]
Componentes: [Lista de componentes necesarios]
Interactividad: [Comportamientos requeridos]
Responsive: [Breakpoints específicos si aplica]
```

## Outputs Esperados

```
## Frontend: [Nombre de la vista/componente]

### Archivos Creados/Modificados
- resources/views/...
- resources/views/components/...
- resources/css/...
- resources/js/...

### Componentes Blade
[Código de componentes]

### Estilos
[Clases Tailwind utilizadas o CSS custom]

### JavaScript/Alpine
[Código de interactividad]

### Checklist de Accesibilidad
- [ ] Navegación por teclado
- [ ] ARIA labels
- [ ] Contraste de colores
- [ ] Focus visible
```

## Definition of Done

- [ ] Vista renderiza correctamente
- [ ] Responsive en mobile, tablet y desktop
- [ ] Componentes reutilizables extraídos
- [ ] Sin errores en consola del navegador
- [ ] Accesibilidad básica verificada
- [ ] Assets compilados sin errores
- [ ] Consistente con diseño del sistema

## Estructura de Archivos Frontend

```
resources/
├── views/
│   ├── layouts/
│   │   ├── app.blade.php           # Layout principal tienda
│   │   ├── admin.blade.php         # Layout panel admin
│   │   └── auth.blade.php          # Layout autenticación
│   │
│   ├── components/
│   │   ├── ui/                     # Componentes UI básicos
│   │   │   ├── button.blade.php
│   │   │   ├── input.blade.php
│   │   │   ├── select.blade.php
│   │   │   ├── modal.blade.php
│   │   │   ├── dropdown.blade.php
│   │   │   ├── alert.blade.php
│   │   │   ├── badge.blade.php
│   │   │   ├── card.blade.php
│   │   │   └── pagination.blade.php
│   │   │
│   │   ├── forms/                  # Componentes de formulario
│   │   │   ├── label.blade.php
│   │   │   ├── error.blade.php
│   │   │   ├── input-group.blade.php
│   │   │   └── checkbox.blade.php
│   │   │
│   │   ├── catalog/                # Componentes de catálogo
│   │   │   ├── product-card.blade.php
│   │   │   ├── product-grid.blade.php
│   │   │   ├── category-nav.blade.php
│   │   │   └── price-display.blade.php
│   │   │
│   │   ├── cart/                   # Componentes de carrito
│   │   │   ├── cart-item.blade.php
│   │   │   ├── cart-summary.blade.php
│   │   │   ├── quantity-selector.blade.php
│   │   │   └── cart-icon.blade.php
│   │   │
│   │   └── admin/                  # Componentes admin
│   │       ├── sidebar.blade.php
│   │       ├── header.blade.php
│   │       ├── stats-card.blade.php
│   │       └── data-table.blade.php
│   │
│   ├── catalog/                    # Vistas de catálogo
│   │   ├── index.blade.php
│   │   └── show.blade.php
│   │
│   ├── cart/                       # Vistas de carrito
│   │   └── index.blade.php
│   │
│   ├── checkout/                   # Vistas de checkout
│   │   ├── index.blade.php
│   │   └── confirmation.blade.php
│   │
│   ├── account/                    # Vistas de cuenta
│   │   ├── dashboard.blade.php
│   │   ├── orders/
│   │   │   ├── index.blade.php
│   │   │   └── show.blade.php
│   │   └── addresses/
│   │       └── index.blade.php
│   │
│   ├── admin/                      # Vistas de admin
│   │   ├── dashboard.blade.php
│   │   ├── products/
│   │   ├── orders/
│   │   ├── users/
│   │   └── settings/
│   │
│   └── auth/                       # Vistas de autenticación
│       ├── login.blade.php
│       ├── register.blade.php
│       └── forgot-password.blade.php
│
├── css/
│   └── app.css                     # Estilos principales (Tailwind)
│
└── js/
    ├── app.js                      # JavaScript principal
    └── components/                 # Componentes JS específicos
        ├── cart.js
        └── dropdown.js
```

## Patrones de Componentes Blade

### Componente Button
```blade
{{-- resources/views/components/ui/button.blade.php --}}
@props([
    'type' => 'button',
    'variant' => 'primary',
    'size' => 'md',
    'disabled' => false,
])

@php
$baseClasses = 'inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed';

$variants = [
    'primary' => 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
    'secondary' => 'bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500',
    'danger' => 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500',
    'outline' => 'border border-gray-300 text-gray-700 hover:bg-gray-50 focus:ring-blue-500',
];

$sizes = [
    'sm' => 'px-3 py-1.5 text-sm',
    'md' => 'px-4 py-2 text-sm',
    'lg' => 'px-6 py-3 text-base',
];

$classes = $baseClasses . ' ' . $variants[$variant] . ' ' . $sizes[$size];
@endphp

<button
    type="{{ $type }}"
    {{ $attributes->merge(['class' => $classes]) }}
    @disabled($disabled)
>
    {{ $slot }}
</button>
```

### Componente Input
```blade
{{-- resources/views/components/ui/input.blade.php --}}
@props([
    'type' => 'text',
    'error' => null,
])

@php
$baseClasses = 'block w-full rounded-lg border-gray-300 shadow-sm transition-colors focus:border-blue-500 focus:ring-blue-500 sm:text-sm';
$errorClasses = $error ? 'border-red-300 text-red-900 focus:border-red-500 focus:ring-red-500' : '';
@endphp

<input
    type="{{ $type }}"
    {{ $attributes->merge(['class' => $baseClasses . ' ' . $errorClasses]) }}
>

@if($error)
    <p class="mt-1 text-sm text-red-600">{{ $error }}</p>
@endif
```

### Componente Product Card
```blade
{{-- resources/views/components/catalog/product-card.blade.php --}}
@props(['product'])

<article class="group relative flex flex-col overflow-hidden rounded-lg border border-gray-200 bg-white">
    {{-- Image --}}
    <div class="aspect-h-4 aspect-w-3 bg-gray-200 sm:aspect-none sm:h-64">
        <img
            src="{{ $product->image_url }}"
            alt="{{ $product->name }}"
            class="h-full w-full object-cover object-center sm:h-full sm:w-full group-hover:opacity-75 transition-opacity"
            loading="lazy"
        >
        @if($product->compare_price)
            <span class="absolute top-2 left-2 inline-flex items-center rounded-full bg-red-100 px-2.5 py-0.5 text-xs font-medium text-red-800">
                Oferta
            </span>
        @endif
    </div>

    {{-- Content --}}
    <div class="flex flex-1 flex-col space-y-2 p-4">
        <h3 class="text-sm font-medium text-gray-900">
            <a href="{{ route('catalog.show', $product->slug) }}">
                <span aria-hidden="true" class="absolute inset-0"></span>
                {{ $product->name }}
            </a>
        </h3>

        <p class="text-sm text-gray-500 line-clamp-2">
            {{ $product->short_description }}
        </p>

        <div class="flex flex-1 flex-col justify-end">
            <x-catalog.price-display :product="$product" />
        </div>
    </div>
</article>
```

### Componente Modal con Alpine.js
```blade
{{-- resources/views/components/ui/modal.blade.php --}}
@props([
    'name',
    'title' => '',
    'maxWidth' => 'md',
])

@php
$maxWidthClasses = [
    'sm' => 'sm:max-w-sm',
    'md' => 'sm:max-w-md',
    'lg' => 'sm:max-w-lg',
    'xl' => 'sm:max-w-xl',
    '2xl' => 'sm:max-w-2xl',
];
@endphp

<div
    x-data="{ open: false }"
    x-on:open-modal.window="if ($event.detail === '{{ $name }}') open = true"
    x-on:close-modal.window="if ($event.detail === '{{ $name }}') open = false"
    x-on:keydown.escape.window="open = false"
    x-show="open"
    x-cloak
    class="relative z-50"
    aria-labelledby="modal-title-{{ $name }}"
    aria-modal="true"
    role="dialog"
>
    {{-- Backdrop --}}
    <div
        x-show="open"
        x-transition:enter="ease-out duration-300"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        x-transition:leave="ease-in duration-200"
        x-transition:leave-start="opacity-100"
        x-transition:leave-end="opacity-0"
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
        @click="open = false"
    ></div>

    {{-- Modal Panel --}}
    <div class="fixed inset-0 z-10 overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
            <div
                x-show="open"
                x-transition:enter="ease-out duration-300"
                x-transition:enter-start="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                x-transition:enter-end="opacity-100 translate-y-0 sm:scale-100"
                x-transition:leave="ease-in duration-200"
                x-transition:leave-start="opacity-100 translate-y-0 sm:scale-100"
                x-transition:leave-end="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full {{ $maxWidthClasses[$maxWidth] }}"
            >
                @if($title)
                    <div class="border-b border-gray-200 px-4 py-3">
                        <h3 id="modal-title-{{ $name }}" class="text-lg font-medium text-gray-900">
                            {{ $title }}
                        </h3>
                    </div>
                @endif

                <div class="px-4 py-5 sm:p-6">
                    {{ $slot }}
                </div>

                @isset($footer)
                    <div class="border-t border-gray-200 bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                        {{ $footer }}
                    </div>
                @endisset
            </div>
        </div>
    </div>
</div>
```

## Convenciones de Tailwind

### Colores del Sistema
```css
/* Paleta principal */
--color-primary: blue-600
--color-primary-hover: blue-700
--color-secondary: gray-600
--color-success: green-600
--color-warning: yellow-600
--color-danger: red-600

/* Texto */
--text-primary: gray-900
--text-secondary: gray-600
--text-muted: gray-400

/* Fondos */
--bg-primary: white
--bg-secondary: gray-50
--bg-muted: gray-100
```

### Espaciado Consistente
```
Padding interno de cards: p-4 (sm), p-6 (md+)
Gap entre elementos: gap-4 (lists), gap-6 (sections)
Margin entre secciones: my-8 (sm), my-12 (md+)
```

### Breakpoints
```
sm: 640px  - Mobile landscape
md: 768px  - Tablets
lg: 1024px - Desktop
xl: 1280px - Large desktop
```

## Accesibilidad (a11y) Checklist

### Cada Componente Debe Tener:
- [ ] `role` apropiado si no es semántico
- [ ] `aria-label` o `aria-labelledby` para elementos interactivos
- [ ] `aria-expanded` para elementos colapsables
- [ ] `aria-hidden="true"` para elementos decorativos
- [ ] Focus visible (`focus:ring-2`)
- [ ] Contraste mínimo 4.5:1 para texto

### Formularios:
- [ ] Labels asociados con `for`
- [ ] Mensajes de error vinculados con `aria-describedby`
- [ ] `aria-invalid="true"` en campos con error
- [ ] `required` y `aria-required` cuando aplique

### Navegación:
- [ ] Skip links al contenido principal
- [ ] `aria-current="page"` en enlace activo
- [ ] Menús con `role="navigation"`

## Comandos de Desarrollo Frontend

```bash
# Compilar assets para desarrollo
npm run dev

# Compilar con hot reload
npm run dev -- --host

# Build para producción
npm run build

# Linting de JavaScript
npm run lint

# Formatear código
npm run format
```

## Integración con Backend

### Pasar Datos a Vistas
```php
// Controller
return view('catalog.show', [
    'product' => $product,
    'relatedProducts' => $related,
]);
```

### Usar en Blade
```blade
{{-- Acceso directo --}}
{{ $product->name }}

{{-- Con fallback --}}
{{ $product->description ?? 'Sin descripción' }}

{{-- Formateo de precio --}}
{{ Number::currency($product->price, 'EUR') }}

{{-- Condicionales --}}
@if($product->isOnSale())
    <x-ui.badge variant="danger">Oferta</x-ui.badge>
@endif
```

## Notas

- Coordinar con `@developer` para datos necesarios en vistas
- Consultar `@security` para sanitización de outputs
- Escalar a deep review para componentes con mucha interactividad
- Usar haiku para componentes UI simples y repetitivos
