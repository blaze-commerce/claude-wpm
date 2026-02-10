---
title: Commands Reference
description: Available commands in Claude WPM.
---

## /wpm - WordPress Maintenance

The primary command for WordPress maintenance tasks.

```bash
/wpm
```

### What it does

1. **Enables maintenance mode** (required for WooCommerce sites)
2. **Updates WordPress core**
3. **Updates database schema**
4. **Updates free plugins**
5. **Updates premium plugins**
6. **Updates themes**
7. **Disables maintenance mode**
8. **Verifies site accessibility**

### Maintenance Mode

Three-tier priority system for maximum compatibility across all sites:

| Priority | Method | When Used | How It Works |
|----------|--------|-----------|--------------|
| 1 | **Woo Site Visibility** | WooCommerce is active | Sets Coming Soon mode via `woocommerce_coming_soon` option |
| 2 | **ASE Pro** | No WooCommerce, ASE Pro active | Uses ASE maintenance mode option |
| 3 | **Custom fallback** | Neither available | Creates `.maintenance` file |

### Important Notes

- Never skip maintenance mode on WooCommerce sites
- Always disable maintenance mode after updates, even if updates fail
- Woo Site Visibility and ASE Pro both work properly with Kinsta CDN
- Custom `.maintenance` may not bypass CDN caching

## /init - Initialize Site

Generates the site-specific `CLAUDE.md` configuration file.

```bash
/init
```

Safe to run multiple times - regenerates configuration as needed.

## Built-in Skills

Invoke with `/skill-name`:

| Command | Description |
|---------|-------------|
| `/wordpress-master` | WordPress/WooCommerce expertise |
| `/php-pro` | PHP development |
| `/security-auditor` | Security review |
| `/database-administrator` | MySQL optimization |
| `/senior-architect` | Architectural decisions and planning |
