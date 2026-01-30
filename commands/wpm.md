# WordPress Maintenance Update

Run WordPress core, plugin, and theme updates in the correct order, then update the plugin inventory in CLAUDE.md.

## Update Order (Best Practice)

Execute these commands in sequence:

### 0. Enable Maintenance Mode (REQUIRED)

**NEVER skip this step** - WooCommerce sites can have failed orders during updates.

First, check if ASE Pro is active:
```bash
wp plugin is-active admin-site-enhancements-pro
```

**If ASE Pro is active (exit code 0):**
```bash
wp option patch update admin_site_enhancements maintenance_mode 1
```
Remember: `MAINTENANCE_METHOD="ase"`

**If ASE Pro is NOT active (exit code 1), use custom fallback:**

First, create `wp-content/maintenance.php` if it doesn't exist:
```php
<?php
header('HTTP/1.1 503 Service Unavailable');
header('Status: 503 Service Unavailable');
header('Retry-After: 3600');
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px;
        }
        h1 { color: #333; margin-bottom: 15px; font-size: 2rem; }
        p { color: #666; font-size: 1.1rem; }
    </style>
</head>
<body>
    <div>
        <h1>We'll be back soon.</h1>
        <p>This site is undergoing maintenance for an extended period today.<br>Thanks for your patience.</p>
    </div>
</body>
</html>
```

Then enable maintenance mode:
```bash
echo '<?php $upgrading = time(); ?>' > .maintenance
```
Remember: `MAINTENANCE_METHOD="custom"`

**Display warning for custom method:**
```
⚠️  WARNING: Using custom maintenance mode. This may not work perfectly
    with CDN caching (cached pages may still be visible). For reliable
    maintenance mode on Kinsta/CDN hosts, install ASE Pro.
```

---

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

**Auto-detection:** The script automatically detects premium plugins installed on this site that are NOT in the repo and reports them. Check `.claude/cache/missing-premium-plugins.txt` for any missing plugins.

### 5. Theme Updates
```bash
wp theme update --all
```

---

### 6. Disable Maintenance Mode (REQUIRED)

**Always disable maintenance mode after updates complete, even if updates failed/errored.**

**If ASE Pro was used (`MAINTENANCE_METHOD="ase"`):**
```bash
wp option patch update admin_site_enhancements maintenance_mode 0
```

**If custom fallback was used (`MAINTENANCE_METHOD="custom"`):**
```bash
rm .maintenance
```
Note: Keep `wp-content/maintenance.php` for future use - only remove the `.maintenance` trigger file.

**Verify maintenance mode is disabled** by checking the site in an incognito browser window.

---

## Premium Plugin Reminder

After running updates, `/wpm` should output a reminder checklist of all premium plugins:

### Output Format
```
⚠️  PREMIUM PLUGIN REMINDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The following premium plugins require manual verification:
┌─────────────────────────────┬───────────┬────────┬────────────────┐
│           Plugin            │ Installed │  Repo  │     Status     │
├─────────────────────────────┼───────────┼────────┼────────────────┤
│ admin-site-enhancements-pro │ 8.3.0     │ 8.3.0  │ ✓ Updated      │
├─────────────────────────────┼───────────┼────────┼────────────────┤
│ oxygen                      │ 4.9.1     │ -      │ ⚠️ Not in repo │
├─────────────────────────────┼───────────┼────────┼────────────────┤
│ gravityforms                │ 2.9.26    │ 2.9.26 │ ✓ Current      │
└─────────────────────────────┴───────────┴────────┴────────────────┘

Action Required:
☐ Verify premium plugins not in repo are up to date
☐ Test Oxygen-related plugins on staging before updating
☐ Update CLAUDE.md plugin inventory with new versions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Special Warnings

Add these warnings to the output when applicable:

1. **Oxygen Builder Warning**: If oxygen, oxygen-woocommerce, oxy-ninja, or oxyultimate-woo are installed:
   ```
   ⚠️  WARNING: Oxygen Builder plugins detected. DO NOT update without testing on staging first.
   ```

2. **Missing from Repo Warning**: If premium plugins are installed but not in wp-premium-plugins repo:
   ```
   ⚠️  These premium plugins are NOT in the update repo:
      - oxygen (4.9.1)
      - oxy-ninja (3.5.3)

   Add zips to wp-premium-plugins repo or update manually.
   ```

---

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

## Required Security Plugin Check

After updates, check if WP 2FA is installed. This is **required** on all Blaze Commerce sites.

```bash
wp plugin is-installed wp-2fa && echo "✓ WP 2FA installed" || echo "⚠️ WP 2FA NOT INSTALLED"
```

### If WP 2FA is NOT installed:

Display this warning prominently:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  SECURITY ALERT: WP 2FA NOT INSTALLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Two-Factor Authentication is REQUIRED on all sites.

Install now:
  wp plugin install wp-2fa --activate

Plugin: https://wordpress.org/plugins/wp-2fa/

After installing:
1. Go to WP Admin → WP 2FA → Setup Wizard
2. Configure 2FA policies for all admin users
3. Enforce 2FA for administrators at minimum

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### If WP 2FA IS installed:

Show brief confirmation:
```
✓ WP 2FA: Installed and active
```

---

## Final Reminders

After completing all tasks, remind the user:
- **VERIFY** maintenance mode is disabled (check site in incognito window)
- **DO NOT** run `wp kinsta cache purge` (causes performance issues)
- Manually clear cache via Kinsta dashboard: https://my.kinsta.com/ → Sites → Tools → Clear cache

---

## Important: Maintenance Mode Notes

- **NEVER skip maintenance mode** - WooCommerce sites can have failed orders during updates
- **ASE Pro is preferred** because it works properly with Kinsta CDN
- The custom `.maintenance` method has limitations on CDN-cached sites (frontend may show cached pages while wp-admin shows maintenance)
- **Always verify** maintenance mode is disabled after updates complete
- **If update fails/errors**, still disable maintenance mode before stopping

## Output Summary

Provide a summary including:
1. Core update status
2. Number of free plugins updated (via `wp plugin update`)
3. Number of premium plugins updated (via `update-premium-plugins.sh`)
4. Number of themes updated
5. Plugin inventory changes (new plugins detected)
6. Reminder to manually clear Kinsta cache
