# Comando: /deploy-check

## Descripción
Checklist pre-deploy para verificar que el código está listo para producción.

## Uso
```
/deploy-check
```

## Flujo de Ejecución

### 1. Tests (Agente: @tester)
```bash
# Ejecutar suite completa
make test

# Verificar cobertura
make test-coverage
```

**Criterios:**
- [ ] Todos los tests pasan
- [ ] Cobertura >80%
- [ ] Tests E2E de checkout pasan
- [ ] Tests E2E de auth pasan

### 2. Calidad de Código (Agente: @developer)
```bash
# Linting
make lint-check

# Static analysis
make analyze
```

**Criterios:**
- [ ] PHP CS Fixer sin errores
- [ ] PHPStan level 8 sin errores
- [ ] Sin warnings ignorados

### 3. Seguridad (Agente: @security)
```bash
# Auditoría de dependencias
composer audit

# Verificar .env
# NO debe existir .env en repo
```

**Criterios:**
- [ ] Sin vulnerabilidades conocidas en dependencias
- [ ] .env no committeado
- [ ] APP_DEBUG=false en producción
- [ ] APP_ENV=production
- [ ] Secrets rotados si es necesario

### 4. Base de Datos (Agente: @database)
```bash
# Verificar migraciones pendientes
php artisan migrate:status

# Verificar que rollback funciona
php artisan migrate:rollback --pretend
```

**Criterios:**
- [ ] Todas las migraciones son reversibles
- [ ] No hay migraciones destructivas sin plan
- [ ] Backup reciente disponible

### 5. Performance (Agente: @developer)
```bash
# Optimizar para producción
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

**Criterios:**
- [ ] Sin N+1 queries detectados
- [ ] Caché configurado
- [ ] Assets compilados y minificados

### 6. Documentación (Agente: @reviewer)
**Criterios:**
- [ ] CHANGELOG actualizado
- [ ] README actualizado si hay cambios de setup
- [ ] API docs actualizados si hay cambios de endpoints

## Checklist Completo

### Código
- [ ] Todos los tests pasan
- [ ] Cobertura >80%
- [ ] PHPStan sin errores
- [ ] CS Fixer sin errores
- [ ] Sin TODOs críticos pendientes

### Seguridad
- [ ] Composer audit limpio
- [ ] .env no en repositorio
- [ ] APP_DEBUG=false
- [ ] Secrets seguros

### Base de Datos
- [ ] Migraciones reversibles
- [ ] Backup verificado
- [ ] Plan de rollback documentado

### Infraestructura
- [ ] Docker images actualizadas
- [ ] Health checks configurados
- [ ] Logging configurado

### Documentación
- [ ] CHANGELOG actualizado
- [ ] Release notes preparadas

## Output del Comando

```
╔══════════════════════════════════════╗
║        DEPLOY CHECK REPORT           ║
╠══════════════════════════════════════╣
║ Tests:          ✅ PASS (156/156)    ║
║ Coverage:       ✅ 84%               ║
║ Linting:        ✅ PASS              ║
║ PHPStan:        ✅ PASS              ║
║ Security:       ✅ No vulnerabilities║
║ Migrations:     ✅ All reversible    ║
║ Documentation:  ✅ Updated           ║
╠══════════════════════════════════════╣
║ STATUS: ✅ READY FOR DEPLOY          ║
╚══════════════════════════════════════╝
```

O si hay problemas:

```
╔══════════════════════════════════════╗
║        DEPLOY CHECK REPORT           ║
╠══════════════════════════════════════╣
║ Tests:          ❌ FAIL (154/156)    ║
║   - ProductTest::testCreate          ║
║   - CartTest::testCheckout           ║
║ Coverage:       ⚠️ 78% (min: 80%)    ║
║ Linting:        ✅ PASS              ║
║ PHPStan:        ✅ PASS              ║
║ Security:       ⚠️ 1 low severity    ║
║ Migrations:     ✅ All reversible    ║
║ Documentation:  ❌ CHANGELOG missing ║
╠══════════════════════════════════════╣
║ STATUS: ❌ NOT READY - Fix issues    ║
╚══════════════════════════════════════╝

Issues to resolve:
1. Fix failing tests
2. Increase coverage to 80%
3. Update CHANGELOG
```

## Notas

- Este comando SIEMPRE usa opus para la revisión final
- No proceder con deploy si hay algún ❌
- Las ⚠️ warnings deben evaluarse caso por caso
- Documentar excepciones si se procede con warnings
