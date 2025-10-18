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

# Wait for database to be ready using simple PHP script (avoid Laravel bootstrapping)
echo "Waiting for database connection..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if php -r "try { new PDO('mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}'); exit(0); } catch (Exception \$e) { exit(1); }" 2>/dev/null; then
        echo "Database connection established!"
        break
    fi
    attempt=$((attempt + 1))
    echo "Database connection attempt $attempt/$max_attempts..."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "Failed to connect to database after $max_attempts attempts"
    exit 1
fi

# Run migrations WITHOUT loading service providers that need existing tables
echo "Running migrations..."
# Temporarily disable the mail receiver driver to prevent IMAP connection during migrations
MAIL_RECEIVER_DRIVER=sendgrid php artisan migrate --force

# Now discover packages with the real configuration
echo "Discovering packages..."
php artisan package:discover --ansi

# Clear and cache Laravel configuration
echo "Caching configuration..."
php artisan config:clear
php artisan config:cache

# Cache routes
echo "Caching routes..."
php artisan route:clear
php artisan route:cache

# Cache views
echo "Caching views..."
php artisan view:clear
php artisan view:cache

echo "Krayin CRM ready!"

# Execute the main command (apache2-foreground)
exec "$@"
