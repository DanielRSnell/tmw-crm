#!/bin/bash
set -e

echo "Starting Krayin CRM..."

# Ensure proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Create directories if they don't exist
mkdir -p /var/www/html/storage/framework/{sessions,views,cache}
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Set permissions
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache

# Wait for database to be ready
echo "Waiting for database connection..."
php artisan db:monitor --max-attempts=30 || echo "Database check failed, continuing anyway..."

# Run migrations first (required before package discovery can access crm_core_config table)
echo "Running migrations..."
php artisan migrate --force

# Discover packages (skipped during build to avoid database access)
echo "Discovering packages..."
php artisan package:discover --ansi

# Clear and cache Laravel configuration
echo "Caching configuration..."
php artisan config:cache

# Cache routes
echo "Caching routes..."
php artisan route:cache

# Cache views
echo "Caching views..."
php artisan view:cache

echo "Krayin CRM ready!"

# Execute the main command (apache2-foreground)
exec "$@"
