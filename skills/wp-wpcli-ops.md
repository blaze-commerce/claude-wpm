# WP-CLI and Operations

Expert guidance for WordPress command-line operations.

## When to Use

Use when you need to:
- Perform search-replace for domain migrations
- Export/import databases
- Manage plugins and themes via CLI
- Handle cron events
- Manage cache operations
- Administer multisite installations

## Safety First

**WP-CLI commands can be destructive.** Before running anything that writes:

1. **Verify environment**: Development, staging, or production?
2. **Confirm targeting**: Correct WordPress installation?
3. **Maintain backups**: Especially for risky operations

## Common Operations

### Search-Replace (Domain Migration)

```bash
# Dry run first
wp search-replace 'old-domain.com' 'new-domain.com' --dry-run

# Execute
wp search-replace 'old-domain.com' 'new-domain.com' --all-tables

# With network for multisite
wp search-replace 'old-domain.com' 'new-domain.com' --network
```

### Database Operations

```bash
# Export
wp db export backup.sql

# Import
wp db import backup.sql

# Optimize
wp db optimize
```

### Plugin Management

```bash
# List plugins
wp plugin list

# Install and activate
wp plugin install akismet --activate

# Update all
wp plugin update --all

# Deactivate
wp plugin deactivate plugin-name
```

### Theme Management

```bash
# List themes
wp theme list

# Activate theme
wp theme activate theme-name

# Update all
wp theme update --all
```

### Cache Operations

```bash
# Clear object cache
wp cache flush

# Clear transients
wp transient delete --all
```

### Cron Management

```bash
# List scheduled events
wp cron event list

# Run specific event
wp cron event run hook_name

# Run all due events
wp cron event run --due-now
```

## Multisite Operations

```bash
# List sites
wp site list

# Run command on specific site
wp --url=site.example.com plugin list

# Run on all sites
wp site list --field=url | xargs -I {} wp --url={} plugin update --all
```

## Configuration

Use `wp-cli.yml` for repeatable setups:
```yaml
path: /var/www/html
url: https://example.com
user: admin
```

## Verification

After operations:
- Run health checks
- Verify site accessibility
- Check error logs

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+
- WP-CLI installed

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-wpcli-and-ops)
