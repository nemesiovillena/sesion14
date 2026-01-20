# Comando: /fix-bug

## Descripción
Workflow para resolver bugs siguiendo el proceso de debugging estructurado.

## Uso
```
/fix-bug [descripción-del-bug]
```

## Flujo de Ejecución

### 1. Preparación
```bash
# Crear branch
git checkout -b fix/[descripción-breve]
```

### 2. Reproducción (Agente: @debugger)
- Identificar pasos para reproducir
- Documentar comportamiento esperado vs actual
- Identificar archivos potencialmente afectados

### 3. Test de Regresión (Agente: @tester)
- Escribir test que reproduzca el bug
- Verificar que el test falla (red)

### 4. Root Cause Analysis (Agente: @debugger)
- Identificar causa raíz
- Documentar el problema
- Proponer solución

### 5. Fix (Agente: @developer)
- Implementar la corrección
- Mantener cambios mínimos y focalizados
- No refactorizar código no relacionado

### 6. Verificación (Agente: @tester)
- Test de regresión debe pasar (green)
- Ejecutar suite completa de tests
- Verificar que no se rompe nada más

### 7. Review (Agente: @reviewer)
- Verificar que el fix es correcto
- Verificar que no introduce nuevos problemas
- Crear PR

## Checklist de Entrega

- [ ] Bug reproducido y documentado
- [ ] Test de regresión escrito
- [ ] Root cause identificado
- [ ] Fix implementado
- [ ] Test de regresión pasa
- [ ] Suite completa de tests pasa
- [ ] Sin cambios innecesarios
- [ ] PR creado con descripción del fix

## Ejemplo de Uso

```
/fix-bug cart-total-calculation-wrong

# Output esperado:
# 1. Crea branch fix/cart-total-calculation
# 2. Reproduce: "Total no incluye descuento"
# 3. Test: test('cart total includes discount')
# 4. Root cause: Método calculateTotal() no resta descuento
# 5. Fix: Añadir substracción de descuento
# 6. Tests pasan
# 7. PR creado
```

## Plantilla de PR para Bugs

```markdown
## Bug Fix: [Título]

### Problema
[Descripción del bug]

### Root Cause
[Causa raíz identificada]

### Solución
[Descripción del fix]

### Tests
- [x] Test de regresión añadido
- [x] Suite completa pasa

### Checklist
- [x] Fix mínimo y focalizado
- [x] Sin side effects
```

## Notas

- NO refactorizar mientras se arregla un bug
- Mantener el fix lo más pequeño posible
- Siempre añadir test de regresión
- Escalar a opus si el bug es en pagos, auth o checkout
