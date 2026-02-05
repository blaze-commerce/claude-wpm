# WordPress Interactivity API

Expert guidance for WordPress Interactivity API development.

## When to Use

Use when you need to:
- Implement `data-wp-*` directives
- Manage client-side state with stores
- Create interactive block experiences
- Debug hydration or directive issues

## Core Concepts

### Basic Structure

```html
<div
    data-wp-interactive="myblock"
    data-wp-context='{"count": 0}'
>
    <span data-wp-text="context.count"></span>
    <button data-wp-on--click="actions.increment">+</button>
</div>
```

### Store Definition

```js
// view.js
import { store } from '@wordpress/interactivity';

store('myblock', {
    state: {
        get doubleCount() {
            const ctx = getContext();
            return ctx.count * 2;
        }
    },
    actions: {
        increment() {
            const ctx = getContext();
            ctx.count++;
        }
    }
});
```

### Server-Side State

```php
// render.php
wp_interactivity_state('myblock', [
    'initialValue' => get_option('my_value')
]);
```

## Common Directives

| Directive | Purpose |
|-----------|---------|
| `data-wp-interactive` | Define store namespace |
| `data-wp-context` | Local reactive state |
| `data-wp-text` | Bind text content |
| `data-wp-bind--attr` | Bind attribute |
| `data-wp-on--event` | Event handler |
| `data-wp-class--name` | Toggle CSS class |
| `data-wp-watch` | Side effects |

## Critical: Server-Side Rendering

Pre-render HTML with correct initial state to prevent:
- Layout shifts
- "Directives don't fire" issues
- Hydration mismatches

```php
// Always set initial state in PHP
wp_interactivity_state('myblock', [
    'isOpen' => false
]);

// Use context for local state
wp_interactivity_data_wp_context([
    'count' => 0
]);
```

## WordPress 6.9 Breaking Changes

- `data-wp-ignore` is deprecated
- Use `---` separator for multiple handlers on one element
- New TypeScript types for async actions

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Directives inert | View script not loaded | Check `viewScriptModule` in block.json |
| Directives inert | Missing namespace | Add `data-wp-interactive` |
| Hydration flicker | State mismatch | Align PHP and JS initial state |

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-interactivity-api)
