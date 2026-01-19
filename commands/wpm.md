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

### 3. Plugin Updates
```bash
wp plugin update --all
```

### 4. Theme Updates
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
2. Number of plugins updated
3. Number of themes updated
4. Plugin inventory changes (new plugins detected)
5. Reminder to manually clear Kinsta cache
