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

# Clear and cache Laravel configuration (only if not already cached)
if [ ! -f /var/www/html/bootstrap/cache/config.php ]; then
    echo "Caching configuration..."
    php artisan config:cache
fi

# Cache routes (only if not already cached)
if [ ! -f /var/www/html/bootstrap/cache/routes-v7.php ]; then
    echo "Caching routes..."
    php artisan route:cache
fi

# Cache views
echo "Caching views..."
php artisan view:cache

# Run migrations (optional - comment out if you want to run manually)
# echo "Running migrations..."
# php artisan migrate --force

echo "Krayin CRM ready!"

# Execute the main command (apache2-foreground)
exec "$@"
