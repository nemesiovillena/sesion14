# Comando: /new-feature

## Descripción
Workflow para implementar una nueva feature siguiendo TDD y las convenciones del proyecto.

## Uso
```
/new-feature [nombre-de-la-feature]
```

## Flujo de Ejecución

### 1. Preparación
```bash
# Crear branch
git checkout -b feature/[nombre-de-la-feature]
```

### 2. Análisis (Agente: @architect)
- Identificar bounded context afectado
- Listar archivos a crear/modificar
- Definir interfaces y contratos
- Documentar decisiones

### 3. Tests First (Agente: @tester)
- Crear tests unitarios para Actions/Services
- Crear tests feature para endpoints
- Verificar que los tests fallan (red)

### 4. Implementación (Agente: @developer)
- Crear migraciones si es necesario
- Implementar Models
- Implementar Actions
- Implementar Controllers
- Implementar Form Requests
- Implementar Policies
- Crear vistas si aplica

### 5. Verificación (Agente: @tester)
- Ejecutar tests (deben pasar - green)
- Verificar cobertura >80%

### 6. Calidad (Agente: @developer)
```bash
# Linting
make lint

# Static analysis
make analyze
```

### 7. Review (Agente: @reviewer)
- Verificar Definition of Done
- Crear PR con descripción

## Checklist de Entrega

- [ ] Branch creado con nomenclatura correcta
- [ ] Tests escritos antes de implementación
- [ ] Código implementado y funcionando
- [ ] Tests pasan (verde)
- [ ] Cobertura >80%
- [ ] PHPStan sin errores
- [ ] PHP CS Fixer sin warnings
- [ ] Form Requests para validación
- [ ] Policies para autorización
- [ ] PR creado

## Ejemplo de Uso

```
/new-feature add-to-cart

# Output esperado:
# 1. Crea branch feature/add-to-cart
# 2. Identifica: Cart bounded context
# 3. Archivos: AddToCartAction, AddToCartRequest, CartController
# 4. Escribe tests
# 5. Implementa feature
# 6. Verifica calidad
# 7. Crea PR
```

## Notas

- Escalar a opus si la feature toca pagos, auth o checkout
- Usar haiku para scaffolding de boilerplate
- Documentar decisiones arquitectónicas si son significativas
