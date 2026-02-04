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

Two-tier approach for maximum compatibility:

| Method | When Used | How It Works |
|--------|-----------|--------------|
| **ASE Pro** (preferred) | Plugin is active | Uses ASE maintenance mode option |
| **Custom fallback** | ASE Pro not available | Creates `.maintenance` file |

### Important Notes

- Never skip maintenance mode on WooCommerce sites
- Always disable maintenance mode after updates, even if updates fail
- ASE Pro method works properly with Kinsta CDN

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
