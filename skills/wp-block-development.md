# WordPress Block Development

Expert guidance for Gutenberg block creation and maintenance.

## When to Use

Use when you need to:
- Create new Gutenberg blocks
- Modify existing blocks
- Handle block.json configuration
- Implement block attributes and rendering
- Manage block deprecations

## Prerequisites

Before starting, identify:
- Repository root and target location (plugin/theme/full site)
- Block name and namespace
- Target WordPress version
- Existing blocks in the project

## Core Workflow

### 1. Scaffold New Blocks
```bash
npx @wordpress/create-block my-block
```
Prefer scaffolding over manual setup.

### 2. API Version
Always use `apiVersion: 3` for WordPress 6.9+:
```json
{
    "apiVersion": 3,
    "name": "my-plugin/my-block",
    "title": "My Block"
}
```

**Note**: WordPress 7.0 will run the post editor in an iframe regardless of block apiVersion.

### 3. Block Types

| Type | Use Case | Implementation |
|------|----------|----------------|
| Static | Saved markup | edit.js + save.js |
| Dynamic | Server-rendered | edit.js + render.php |
| Interactive | Frontend behavior | viewScriptModule + Interactivity API |

### 4. Handle Changes Safely
When modifying saved markup or attributes, always add `deprecated` entries:
```js
deprecated: [
    {
        attributes: { /* old attributes */ },
        save: function(props) { /* old save */ }
    }
]
```
This prevents "Invalid block" errors.

### 5. Server-Side Registration
```php
register_block_type(__DIR__ . '/build/my-block');
```
Prefer PHP registration for dynamic rendering or translations.

## Verification Checklist

- [ ] Block inserts successfully in editor
- [ ] Block saves without errors
- [ ] Frontend renders correctly
- [ ] Assets load appropriately
- [ ] Passes linting/testing

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+
- Node.js for build tooling

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-block-development)
