# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Krayin CRM** - a Laravel-based Customer Relationship Management system built with a modular package architecture. It's designed as a complete CRM solution for SMEs and Enterprises with features like lead management, contact management, email integration, and more.

## Architecture

### Modular Package Structure
The codebase follows a modular architecture with packages located in `packages/Webkul/`:

- **Core**: Main system functionality and base classes
- **Admin**: Administrative interface and controllers
- **Contact**: Customer contact management
- **Lead**: Lead tracking and management
- **Email**: Email integration and templates
- **User**: User management and authentication
- **Activity**: Activity tracking and logging
- **Product**: Product catalog management
- **Quote**: Quote generation and management
- **WebForm**: Web form builder functionality
- **Automation**: Workflow automation features

Each package contains its own `src/` directory with Models, Controllers, Resources, and other Laravel components.

### Laravel Application Structure
- **app/**: Standard Laravel application files (Console, Http, Models, Providers)
- **packages/Webkul/**: Modular CRM packages with individual functionality
- **config/**: Laravel configuration files including CRM-specific configs
- **resources/**: Frontend assets, views, and language files
- **database/**: Migrations, factories, and seeders

## Common Commands

### Development
```bash
# Start development server
php artisan serve

# Install and setup (fresh installation)
php artisan krayin-crm:install

# Clear routes cache
php artisan route:clear
```

### Frontend Assets
```bash
# Development build
npm run dev

# Production build
npm run build
```

### Testing
```bash
# Run all tests (uses Pest framework)
vendor/bin/pest

# Run PHPUnit tests
vendor/bin/phpunit

# Run specific test suite
vendor/bin/phpunit tests/Unit
vendor/bin/phpunit tests/Feature
```

### Code Quality
```bash
# Run Laravel Pint (code formatting)
vendor/bin/pint

# Check code style without fixing
vendor/bin/pint --test
```

### Production Deployment
```bash
# Install production dependencies only
composer install --no-dev
```

## Key Configuration Files

- **composer.json**: Defines autoloading for all Webkul packages
- **config/concord.php**: Package discovery and modular system configuration
- **pint.json**: Code style rules (Laravel preset with custom binary operator spacing)
- **phpunit.xml**: Test configuration with separate Unit and Feature test suites
- **vite.config.js**: Frontend build configuration

## Development Notes

- Uses **Pest** as the primary testing framework alongside PHPUnit
- Code formatting follows **Laravel Pint** standards
- Package discovery handled by **Konekt Concord** package
- Frontend built with **Vite** and Laravel Vite plugin
- Modular packages are symlinked via Composer for local development