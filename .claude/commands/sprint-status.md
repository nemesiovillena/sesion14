# Comando: /sprint-status

## Descripción
Muestra el estado detallado del sprint actual o de un sprint específico.

## Uso
```
/sprint-status [número-sprint]
```

### Parámetros
- `número-sprint` (opcional): 1-12. Si no se especifica, muestra el sprint actual.

### Ejemplos
```
/sprint-status        # Muestra sprint actual
/sprint-status 1      # Muestra Sprint 1
/sprint-status 5      # Muestra Sprint 5
```

## Output Esperado

```
╔══════════════════════════════════════════════════════════════════╗
║                    SPRINT 1: Setup y Arquitectura Base           ║
╠══════════════════════════════════════════════════════════════════╣
║ Estado: 🔄 En Progreso                                           ║
║ Fechas: 2026-01-20 → 2026-02-03                                  ║
║ Progreso: ████████░░ 80% (8/10 tareas)                          ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║ TAREAS COMPLETADAS (8)                                           ║
║ ─────────────────────                                            ║
║ ✅ S1-01 Crear proyecto Laravel 12              @devops          ║
║ ✅ S1-02 Configurar Docker                      @devops          ║
║ ✅ S1-03 Configurar .env                        @devops          ║
║ ✅ S1-04 Instalar dependencias                  @developer       ║
║ ✅ S1-05 Crear estructura Domain/               @architect       ║
║ ✅ S1-06 Configurar PHPStan                     @developer       ║
║ ✅ S1-07 Configurar Pint                        @developer       ║
║ ✅ S1-08 Configurar Pest                        @tester          ║
║                                                                  ║
║ TAREAS EN PROGRESO (1)                                           ║
║ ──────────────────────                                           ║
║ 🔄 S1-09 Pipeline CI                            @devops          ║
║                                                                  ║
║ TAREAS PENDIENTES (1)                                            ║
║ ─────────────────────                                            ║
║ ⬜ S1-10 Documentar README                      @developer       ║
║                                                                  ║
║ BLOQUEADORES (0)                                                 ║
║ ──────────────                                                   ║
║ Ninguno                                                          ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║ Siguiente tarea sugerida: S1-09 Pipeline CI                      ║
║ Agente asignado: @devops                                         ║
╚══════════════════════════════════════════════════════════════════╝
```

## Información Mostrada

### Cabecera
- Nombre y número del sprint
- Estado general (No iniciado, En progreso, Completado, Bloqueado)
- Fechas de inicio y fin planificadas
- Barra de progreso visual

### Tareas por Estado
1. **Completadas**: Tareas con ✅
2. **En Progreso**: Tareas con 🔄
3. **Pendientes**: Tareas con ⬜
4. **Bloqueadas**: Tareas con ❌

### Para cada tarea
- ID de la tarea
- Descripción breve
- Agente responsable
- Notas (si las hay)

### Bloqueadores
- Lista de bloqueadores activos
- Acción requerida para desbloquear

### Sugerencias
- Siguiente tarea a abordar
- Agente que debería tomarla

## Cálculos

### Progreso del Sprint
```
progreso = (tareas_completadas / total_tareas) * 100
```

### Estado del Sprint
```
Si todas completadas → "Completado"
Si alguna bloqueada → "Bloqueado"
Si alguna en progreso → "En Progreso"
Si ninguna iniciada → "No iniciado"
```

## Integración con PROGRESS.md

El comando lee el estado desde `.claude/PROGRESS.md` y lo formatea para visualización rápida.

## Variante: /sprint-status all

Muestra resumen de todos los sprints:

```
╔═══════════════════════════════════════════════════════════════╗
║                    RESUMEN DE SPRINTS                          ║
╠═══════════════════════════════════════════════════════════════╣
║ Sprint  │ Nombre                    │ Estado    │ Progreso    ║
║─────────┼───────────────────────────┼───────────┼─────────────║
║    1    │ Setup y Arquitectura      │ ✅ 100%   │ ██████████  ║
║    2    │ Modelos y Migraciones     │ 🔄 60%    │ ██████░░░░  ║
║    3    │ Catálogo de Productos     │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    4    │ Autenticación             │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    5    │ Panel Admin               │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    6    │ Carrito                   │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    7    │ Checkout                  │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    8    │ Pagos                     │ ⬜ 0%     │ ░░░░░░░░░░  ║
║    9    │ Inventario                │ ⬜ 0%     │ ░░░░░░░░░░  ║
║   10    │ Pre-Producción            │ ⬜ 0%     │ ░░░░░░░░░░  ║
║   11    │ Deploy Easypanel          │ ⬜ 0%     │ ░░░░░░░░░░  ║
║   12    │ Mejoras                   │ ⬜ 0%     │ ░░░░░░░░░░  ║
╠═══════════════════════════════════════════════════════════════╣
║ PROGRESO TOTAL: ████░░░░░░░░░░░░░░░░ 13% (21/161 tareas)      ║
╚═══════════════════════════════════════════════════════════════╝
```

## Notas

- Ejecutar al inicio de cada sesión de trabajo
- Útil para daily standups virtuales
- Ayuda a identificar cuellos de botella
- Facilita la priorización de tareas
