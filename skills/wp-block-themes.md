# WordPress Block Themes

Expert guidance for block theme development.

## When to Use

Use when you need to:
- Create or modify block themes
- Work with theme.json configuration
- Create templates and template parts
- Add patterns and style variations
- Troubleshoot style application issues

## File Structure

```
theme/
├── style.css           # Theme header
├── theme.json          # Global styles and settings
├── templates/          # Block templates (HTML)
│   ├── index.html
│   ├── single.html
│   └── page.html
├── parts/              # Template parts (HTML)
│   ├── header.html
│   └── footer.html
├── patterns/           # Block patterns (PHP)
│   └── hero.php
└── styles/             # Style variations (JSON)
    └── dark.json
```

## Style Hierarchy

Understanding the cascade is critical:
1. Core defaults
2. theme.json
3. Child theme
4. User customizations

**Note**: User selections can mask theme edits.

## theme.json Basics

```json
{
    "$schema": "https://schemas.wp.org/trunk/theme.json",
    "version": 3,
    "settings": {
        "color": {
            "palette": [
                { "slug": "primary", "color": "#0073aa", "name": "Primary" }
            ]
        }
    },
    "styles": {
        "color": {
            "background": "var(--wp--preset--color--primary)"
        }
    }
}
```

## Templates

Templates are HTML files with block markup:
```html
<!-- wp:template-part {"slug":"header"} /-->
<!-- wp:post-content /-->
<!-- wp:template-part {"slug":"footer"} /-->
```

## Patterns

Patterns are PHP files with block markup:
```php
<?php
/**
 * Title: Hero
 * Slug: theme-name/hero
 * Categories: featured
 */
?>
<!-- wp:cover {"url":"image.jpg"} -->
<div class="wp-block-cover">...</div>
<!-- /wp:cover -->
```

## Troubleshooting

If styles aren't applying, verify:
- [ ] Correct theme is active
- [ ] User customizations not overriding
- [ ] theme.json syntax is valid (use JSON validator)
- [ ] Files are in proper directories
- [ ] Cache is cleared

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-block-themes)
