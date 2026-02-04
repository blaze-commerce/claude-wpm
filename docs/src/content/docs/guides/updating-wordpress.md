---
title: Updating WordPress Sites
description: How to safely update WordPress core, plugins, and themes.
---

This guide covers the recommended workflow for updating WordPress sites using Claude WPM.

## Quick Update

For a standard update with maintenance mode:

```bash
/wpm
```

This runs the full update sequence automatically.

## Manual Update Steps

If you need more control:

### 1. Enable Maintenance Mode

```bash
# Check if ASE Pro is available
wp plugin is-active admin-site-enhancements-pro

# If yes, use ASE
wp option patch update admin_site_enhancements maintenance_mode 1

# If no, use fallback
echo '<?php $upgrading = time(); ?>' > .maintenance
```

### 2. Update Core

```bash
wp core update
wp core update-db
```

### 3. Update Plugins

```bash
# Free plugins
wp plugin update --all

# Premium plugins (if using blz-wpm.sh)
bash .claude/scripts/blz-wpm.sh
```

### 4. Update Themes

```bash
wp theme update --all
```

### 5. Disable Maintenance Mode

```bash
# If using ASE
wp option patch update admin_site_enhancements maintenance_mode 0

# If using fallback
rm .maintenance
```

### 6. Verify

- Check site is accessible in incognito browser
- Clear Kinsta cache if applicable
- Test critical functionality (checkout, forms, etc.)

## WooCommerce Sites

**Important:** Always use maintenance mode for WooCommerce sites. Updates without maintenance mode can cause:

- Failed orders during update
- Broken checkout process
- Database inconsistencies

## Troubleshooting

### Site stuck in maintenance mode

```bash
# Remove maintenance file
rm .maintenance

# Or disable ASE maintenance mode
wp option patch update admin_site_enhancements maintenance_mode 0
```

### Update failed mid-process

1. Disable maintenance mode immediately
2. Check error logs: `wp eval 'var_dump(WP_DEBUG_LOG);'`
3. Verify database: `wp db check`
4. Re-run failed update individually
