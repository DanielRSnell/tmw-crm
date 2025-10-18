#!/bin/sh
set -e

echo "Starting Krayin CRM..."

# Ensure proper permissions
chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Create directories if they don't exist
mkdir -p /app/storage/framework/{sessions,views,cache}
mkdir -p /app/storage/logs
mkdir -p /app/bootstrap/cache

# Set permissions
chmod -R 775 /app/storage
chmod -R 775 /app/bootstrap/cache

# Clear and cache Laravel configuration (only if not already cached)
if [ ! -f /app/bootstrap/cache/config.php ]; then
    echo "Caching configuration..."
    php artisan config:cache
fi

# Cache routes (only if not already cached)
if [ ! -f /app/bootstrap/cache/routes-v7.php ]; then
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

# Execute the main command
exec "$@"
