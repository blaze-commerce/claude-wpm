# WordPress PHPStan

Expert guidance for PHPStan static analysis in WordPress projects.

## When to Use

Use when you need to:
- Set up or modify phpstan.neon configuration
- Create or update baseline files
- Fix type issues with WordPress-specific annotations
- Manage third-party plugin/theme class resolution

## Prerequisites

- Composer-based setup
- WordPress stubs installed

## Setup

### Install Dependencies

```bash
composer require --dev phpstan/phpstan szepeviktor/phpstan-wordpress
```

### Basic Configuration

```neon
# phpstan.neon
includes:
    - vendor/szepeviktor/phpstan-wordpress/extension.neon

parameters:
    level: 6
    paths:
        - src/
        - includes/
    excludePaths:
        - vendor/
    bootstrapFiles:
        - vendor/autoload.php
```

## WordPress Stubs

**Critical**: Without WordPress stubs, expect high volumes of errors about unknown core functions.

```bash
# Option 1: szepeviktor extension (recommended)
composer require --dev szepeviktor/phpstan-wordpress

# Option 2: Manual stubs
composer require --dev php-stubs/wordpress-stubs
```

## Type Fixes Over Ignores

**Prefer fixing root causes** through proper PHPDoc annotations:

### REST Endpoints
```php
/**
 * @param WP_REST_Request $request
 * @return WP_REST_Response|WP_Error
 */
function my_rest_callback($request) {
    // ...
}
```

### Hook Callbacks
```php
/**
 * @param string $content
 * @return string
 */
function my_filter($content) {
    return $content;
}
add_filter('the_content', 'my_filter');
```

### Database Queries
```php
/** @var wpdb $wpdb */
global $wpdb;
```

## Baseline Management

Use baselines for legacy code migration, not for new issues:

```bash
# Generate baseline
vendor/bin/phpstan analyse --generate-baseline

# Run with baseline
vendor/bin/phpstan analyse
```

## Third-Party Classes

1. Verify plugin is actually installed
2. Check for existing stub packages
3. Add targeted ignore patterns only as last resort

```neon
parameters:
    ignoreErrors:
        - '#^Call to method .* on an unknown class SomePluginClass#'
```

## Verification

After configuration changes:
1. Run PHPStan
2. Monitor baseline doesn't unexpectedly grow
3. Check for autoloading issues

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Many "unknown function" errors | Missing stubs | Install WordPress stubs |
| Class not found | Missing autoload | Check Composer autoload |
| Too many errors | Paths too broad | Refine `paths` config |

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+
- Composer required

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-phpstan)
