# WordPress REST API

Expert guidance for building and debugging WordPress REST endpoints.

## When to Use

Use when you need to:
- Create or update REST routes
- Troubleshoot permission (401/403) or routing (404) errors
- Add custom fields/meta to REST responses
- Expose custom post types via REST
- Implement authentication strategies

## Core Concepts

### Register Custom Endpoint

```php
add_action('rest_api_init', function() {
    register_rest_route('myplugin/v1', '/items', [
        'methods' => 'GET',
        'callback' => 'get_items_callback',
        'permission_callback' => function() {
            return current_user_can('read');
        },
        'args' => [
            'per_page' => [
                'type' => 'integer',
                'default' => 10,
                'sanitize_callback' => 'absint'
            ]
        ]
    ]);
});
```

### Expose Custom Post Type

```php
register_post_type('book', [
    'show_in_rest' => true,
    'rest_base' => 'books',
    'rest_controller_class' => 'WP_REST_Posts_Controller',
]);
```

### Add Custom Field to Response

```php
register_rest_field('post', 'custom_field', [
    'get_callback' => function($post) {
        return get_post_meta($post['id'], 'custom_field', true);
    },
    'schema' => [
        'type' => 'string',
        'description' => 'Custom field value'
    ]
]);
```

## Authentication Methods

| Method | Use Case |
|--------|----------|
| Cookie + Nonce | Admin/logged-in contexts |
| Application Passwords | External clients |
| OAuth/JWT | Third-party integrations |

### Cookie + Nonce Example
```js
fetch('/wp-json/wp/v2/posts', {
    headers: {
        'X-WP-Nonce': wpApiSettings.nonce
    }
});
```

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| 404 | Missing `rest_api_init` | Register routes on correct hook |
| 401 | Missing nonce | Include X-WP-Nonce header |
| 403 | Permission denied | Check `permission_callback` |

## Verification

- [ ] Namespace appears in `/wp-json/`
- [ ] `OPTIONS` requests return schema
- [ ] Proper status codes for auth failures
- [ ] CPT routes display under `wp/v2`

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-rest-api)
