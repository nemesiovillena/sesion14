# Products&Inventory - Ecommerce API

Sistema de gestión de inventario y ecommerce construido con **Laravel 12** y **PHP 8.4**.

## 🚀 Tecnologías Principales

- **Framework**: Laravel 12.x
- **Lenguaje**: PHP 8.4
- **Base de Datos**: MariaDB 11.4
- **Cache/Queue**: Redis 7.4
- **Testing**: Pest PHP
- **Análisis Estático**: PHPStan (Larastan) Level 8
- **Estilo de Código**: Laravel Pint
- **Contenedores**: Docker & Docker Compose

## 🛠️ Requisitos

- Docker y Docker Compose
- Make (opcional, pero recomendado)

## 📦 Instalación y Setup Inicial

El proyecto utiliza un `Makefile` para simplificar las tareas comunes.

1. **Clonar el repositorio y entrar en la carpeta**:
   ```bash
   git clone https://github.com/nemesiovillena/sesion14.git
   cd sesion14
   ```

2. **Instalación completa**:
   Este comando levantará los contenedores, instalará dependencias, generará la key, ejecutará migraciones y seeders.
   ```bash
   make install
   ```

3. **Acceder a la aplicación**:
   - **API/Web**: [http://localhost:8080](http://localhost:8080)
   - **Mailpit**: [http://localhost:8025](http://localhost:8025)

## ⌨️ Comandos Disponibles (Makefile)

- `make up`: Levanta los contenedores en segundo plano.
- `make down`: Detiene los contenedores.
- `make test`: Ejecuta la suite de pruebas con Pest.
- `make lint`: Corrige el estilo de código con Laravel Pint.
- `make analyze`: Ejecuta el análisis estático con PHPStan.
- `make shell`: Entra en la terminal del contenedor de la aplicación.
- `make migrate`: Ejecuta las migraciones de base de datos.

## 📈 Seguimiento del Proyecto

Puedes consultar el estado detallado del desarrollo en los siguientes archivos:
- [Roadmap de Desarrollo](.claude/ROADMAP.md)
- [Seguimiento de Progreso](.claude/PROGRESS.md)

---
Desarrollado con ❤️ para el curso de CodeIA.
