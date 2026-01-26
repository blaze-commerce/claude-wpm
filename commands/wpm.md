# WordPress Maintenance Update

Run WordPress core, plugin, and theme updates in the correct order, then update the plugin inventory in CLAUDE.md.

## Update Order (Best Practice)

Execute these commands in sequence:

### 1. WordPress Core Update
```bash
wp core update
```

### 2. Database Update
```bash
wp core update-db
```

### 3. Free Plugin Updates (via wordpress.org)
```bash
wp plugin update --all
```

### 4. Premium Plugin Updates (via private repo)
```bash
.claude/scripts/update-premium-plugins.sh update-all
```

This pulls from `git@github.com:blaze-commerce/wp-premium-plugins.git` and updates:
- elementor-pro
- gp-premium
- perfmatters
- woo-checkout-field-editor-pro
- admin-site-enhancements-pro
- wp-mail-smtp-pro
- surerank-pro

**Note:** Only updates plugins that have a zip file in the repo. If a premium plugin shows "no zip in repo", the user needs to upload the latest version to the repo first.

### 5. Theme Updates
```bash
wp theme update --all
```

## After Updates: Update Plugin Inventory

After running the updates, you MUST update the "Plugin Inventory" section in CLAUDE.md:

### Step 1: Get Current Plugin List
```bash
wp plugin list --format=csv --fields=name,status,version
```

### Step 2: Compare with Existing List
- Read the current "Plugin Inventory" section in CLAUDE.md
- Compare with the new plugin list from WP-CLI

### Step 3: Update CLAUDE.md
- Update the plugin list with current status and versions
- If a plugin is NEW (not in the previous list), add `← NEW` marker next to it
- Add timestamp of when the update was performed

### Format for Plugin Inventory
```markdown
## Plugin Inventory

Last updated: [DATE] via `/wpm`

### Active Plugins
| Plugin | Version | Notes |
|--------|---------|-------|
| woocommerce | 8.5.0 | |
| new-plugin | 1.0.0 | ← NEW |

### Inactive Plugins
| Plugin | Version | Notes |
|--------|---------|-------|
| old-plugin | 2.0.0 | |
```

## Final Reminders

After completing all tasks, remind the user:
- **DO NOT** run `wp kinsta cache purge` (causes performance issues)
- Manually clear cache via Kinsta dashboard: https://my.kinsta.com/ → Sites → Tools → Clear cache

## Output Summary

Provide a summary including:
1. Core update status
2. Number of free plugins updated (via `wp plugin update`)
3. Number of premium plugins updated (via `update-premium-plugins.sh`)
4. Number of themes updated
5. Plugin inventory changes (new plugins detected)
6. Reminder to manually clear Kinsta cache
