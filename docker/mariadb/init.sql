-- Products&Inventory - MariaDB Initialization Script
-- This script runs when the container is created for the first time

-- Create testing database for PHPUnit
CREATE DATABASE IF NOT EXISTS products_inventory_testing;

-- Grant all privileges to the application user
GRANT ALL PRIVILEGES ON products_inventory.* TO 'laravel'@'%';
GRANT ALL PRIVILEGES ON products_inventory_testing.* TO 'laravel'@'%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Set timezone
SET GLOBAL time_zone = 'Europe/Madrid';

-- Performance optimizations for development
SET GLOBAL innodb_buffer_pool_size = 256 * 1024 * 1024;
SET GLOBAL innodb_log_file_size = 64 * 1024 * 1024;
SET GLOBAL max_connections = 100;

-- Character set configuration
SET GLOBAL character_set_server = 'utf8mb4';
SET GLOBAL collation_server = 'utf8mb4_unicode_ci';
