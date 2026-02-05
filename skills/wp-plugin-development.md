# WordPress Plugin Development

Expert guidance for WordPress plugin creation and maintenance.

## When to Use

Use when you need to:
- Create a new WordPress plugin
- Maintain or update existing plugins
- Implement plugin architecture patterns
- Add admin interfaces or settings pages
- Handle plugin lifecycle (activation, deactivation, uninstall)

## Core Architecture

### Bootstrap Structure
- Single bootstrap file with plugin header
- Dedicated loader class for hook registration
- Defer heavy processing to hooks, not load-time

### Lifecycle Hooks
```php
// Activation - must be at top level
register_activation_hook(__FILE__, 'my_plugin_activate');

// Deactivation
register_deactivation_hook(__FILE__, 'my_plugin_deactivate');

// Uninstall - use uninstall.php or register_uninstall_hook
```

**Important**: Hooks must be registered at top-level, not inside other hooks.

## Settings API Pattern

```php
// Register setting
register_setting('my_plugin_options', 'my_option', [
    'sanitize_callback' => 'sanitize_text_field'
]);

// Add section
add_settings_section('my_section', 'Section Title', 'callback', 'my-plugin');

// Add field
add_settings_field('my_field', 'Field Label', 'render_callback', 'my-plugin', 'my_section');
```

## Security Requirements

- **Input**: Validate/sanitize input early
- **Output**: Escape output late
- **Nonces**: Always use with capability checks
- **Database**: Use `$wpdb->prepare()` for all queries

## Data Storage

| Type | Use Case |
|------|----------|
| Options API | Small configuration data |
| Custom Tables | Large/complex data (justify need) |
| Transients | Cached/temporary data |

## Verification Checklist

- [ ] Activation succeeds without errors
- [ ] Settings persist with proper authorization
- [ ] Nonces validate correctly
- [ ] Uninstall removes only intended data
- [ ] No PHP warnings/notices

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-plugin-development)
