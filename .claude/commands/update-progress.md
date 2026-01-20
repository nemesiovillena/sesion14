# Comando: /update-progress

## Descripción
Actualiza el archivo PROGRESS.md marcando tareas completadas y actualizando métricas.

## Uso
```
/update-progress [sprint] [tarea-id] [estado]
```

### Parámetros
- `sprint`: Número de sprint (1-12)
- `tarea-id`: ID de la tarea (ej: S1-01, S2-03)
- `estado`: completado | en_progreso | bloqueado | pendiente

### Ejemplos
```
/update-progress 1 S1-01 completado
/update-progress 1 S1-02 en_progreso
/update-progress 2 S2-05 bloqueado
```

## Flujo de Ejecución

### 1. Validar Sprint y Tarea
- Verificar que el sprint existe (1-12)
- Verificar que la tarea existe en ese sprint
- Validar estado permitido

### 2. Actualizar PROGRESS.md
- Cambiar símbolo de estado de la tarea
- Añadir timestamp de actualización
- Si es "completado", añadir ✅
- Si es "en_progreso", añadir 🔄
- Si es "bloqueado", añadir ❌

### 3. Recalcular Progreso
- Calcular % de tareas completadas del sprint
- Calcular % de progreso total del proyecto
- Actualizar barra de progreso visual

### 4. Actualizar Métricas (si aplica)
- Si la tarea es de tests, actualizar cobertura
- Si la tarea es de quality, actualizar checks

## Mapeo de Estados

| Input | Símbolo | Descripción |
|-------|---------|-------------|
| pendiente | ⬜ | No iniciado |
| en_progreso | 🔄 | Trabajando |
| completado | ✅ | Terminado |
| bloqueado | ❌ | Tiene bloqueador |
| pausado | ⏸️ | Detenido temporalmente |

## Output Esperado

```
## Progreso Actualizado

Sprint 1: Setup y Arquitectura Base
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ S1-01: Crear proyecto Laravel 12
🔄 S1-02: Configurar Docker
⬜ S1-03: Configurar .env
...

Progreso Sprint 1: ██░░░░░░░░ 20% (2/10)
Progreso Total:    █░░░░░░░░░ 10%

Última actualización: 2026-01-20 15:30
```

## Actualización Automática de Barra de Progreso

```
Fórmula:
- Cada sprint tiene peso igual (100/12 = 8.33%)
- Dentro del sprint, cada tarea tiene peso igual
- Progreso total = Σ (tareas completadas / total tareas) * peso sprint

Ejemplo:
Sprint 1: 5/10 tareas = 50% del sprint = 4.16% del total
Sprint 2: 0/14 tareas = 0% del sprint = 0% del total
...
Progreso total = 4.16%
```

## Tareas por Sprint (referencia)

| Sprint | Total Tareas |
|--------|--------------|
| 1 | 10 |
| 2 | 14 |
| 3 | 13 |
| 4 | 14 |
| 5 | 14 |
| 6 | 14 |
| 7 | 16 |
| 8 | 13 |
| 9 | 12 |
| 10 | 14 |
| 11 | 16 |
| 12 | 11 |
| **Total** | **161** |

## Integración con TodoWrite

Cuando se marca una tarea como completada, también se debe actualizar el TodoWrite tool para mantener sincronía:

```
1. Leer estado actual de PROGRESS.md
2. Actualizar tarea específica
3. Recalcular porcentajes
4. Guardar PROGRESS.md
5. Actualizar TodoWrite con estado actual del sprint
```

## Notas

- Este comando debe ejecutarse cada vez que se complete una tarea
- Mantiene trazabilidad del progreso real vs planificado
- Permite identificar sprints retrasados rápidamente
- El archivo PROGRESS.md sirve como fuente de verdad del estado del proyecto
