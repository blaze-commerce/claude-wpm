# WordPress Abilities API

Expert guidance for WordPress Abilities API implementation.

## When to Use

Use when you need to:
- Register abilities and categories in PHP
- Expose abilities via REST endpoints
- Consume abilities in JavaScript with `@wordpress/abilities`
- Build capability-based permission systems

## Core Concepts

The Abilities API provides a standardized way to define and check what users can do, beyond traditional WordPress capabilities.

## PHP Registration

### Register a Category

```php
add_action('init', function() {
    wp_register_ability_category('my-plugin', [
        'label' => __('My Plugin Abilities', 'my-plugin')
    ]);
});
```

### Register an Ability

```php
add_action('init', function() {
    wp_register_ability('my-plugin/can-export', [
        'label' => __('Export Data', 'my-plugin'),
        'category' => 'my-plugin',
        'meta' => [
            'show_in_rest' => true  // Critical for JS access
        ]
    ]);
});
```

**Important**: `show_in_rest: true` is required for client-side visibility.

## Check Abilities

### In PHP

```php
if (current_user_has_ability('my-plugin/can-export')) {
    // Allow export
}
```

### In JavaScript

```js
import { useAbility } from '@wordpress/abilities';

function MyComponent() {
    const canExport = useAbility('my-plugin/can-export');

    if (!canExport) {
        return null;
    }

    return <ExportButton />;
}
```

## REST Endpoints

Abilities are exposed at:
```
GET /wp-json/wp/v2/abilities
GET /wp-json/wp/v2/ability-categories
```

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Ability not in REST | Missing `show_in_rest` | Add to meta array |
| Registration not working | Wrong hook timing | Use `init` action |
| JS can't access | Build tools issue | Check @wordpress/abilities import |

## Verification

1. Check ability appears in REST response
2. Verify JavaScript client can read abilities
3. Confirm permission checks work correctly

## Target Environment

- WordPress 6.9+ (Abilities API support)
- PHP 7.2.24+
- @wordpress/abilities package for JS

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-abilities-api)
