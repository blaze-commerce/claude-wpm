# WordPress Maintenance Update

Run WordPress core, plugin, and theme updates in the correct order, then update the plugin inventory in CLAUDE.md.

## Update Order (Best Practice)

Execute these commands in sequence:

### 0. Enable Maintenance Mode (REQUIRED)

**NEVER skip this step** - WooCommerce sites can have failed orders during updates.

Maintenance mode uses a 3-tier priority system. Check in order:

#### Priority 1: WooCommerce Site Visibility (Coming Soon)

```bash
wp plugin is-active woocommerce
```

**If WooCommerce is active (exit code 0):**
```bash
wp option update woocommerce_coming_soon "yes" --autoload=yes
```
Remember: `MAINTENANCE_METHOD="woo"`

This sets the site to **Coming Soon** mode via WooCommerce → Settings → Site Visibility. Native, CDN-friendly, no extra plugin needed.

#### Priority 2: ASE Pro Maintenance Mode

Only if WooCommerce is NOT active:
```bash
wp plugin is-active admin-site-enhancements-pro
```

**If ASE Pro is active (exit code 0):**
```bash
wp option patch update admin_site_enhancements maintenance_mode 1
```
Remember: `MAINTENANCE_METHOD="ase"`

#### Priority 3: Custom .maintenance Fallback

Only if neither WooCommerce nor ASE Pro is active.

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
    maintenance mode, use a WooCommerce or ASE Pro site.
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

**If WooCommerce Coming Soon was used (`MAINTENANCE_METHOD="woo"`):**
```bash
wp option update woocommerce_coming_soon "no"
```
This sets the site back to **Live** via WooCommerce Site Visibility.

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
- **Priority 1: WooCommerce Site Visibility** (Coming Soon) — native, CDN-friendly, works on all WooCommerce sites
- **Priority 2: ASE Pro** — for non-WooCommerce sites that have ASE Pro installed
- **Priority 3: Custom `.maintenance`** — last resort, has limitations on CDN-cached sites (frontend may show cached pages)
- **Always verify** maintenance mode is disabled after updates complete
- **If update fails/errors**, still disable maintenance mode before stopping

## Output Summary (REQUIRED)

After ALL updates complete, you MUST display this visual summary. Copy this exact format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                         ✅ UPDATE COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────────┐
│                        UPDATE SUMMARY                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  🔒 Maintenance Mode    [METHOD: woo/ase/custom] enabled → disabled  │
│                                                                     │
│  ⬆️  WordPress Core      [OLD_VERSION] → [NEW_VERSION]              │
│  🗄️  Database            [STATUS - updated/already latest]          │
│  🔌 Free Plugins        [COUNT] updated                             │
│  💎 Premium Plugins     [COUNT] updated                             │
│  🎨 Themes              [COUNT] updated                             │
│  📋 CLAUDE.md           Updated with new versions                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### If Premium Plugins Need Manual Update

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️  PREMIUM PLUGINS NEED MANUAL UPDATE                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Plugin                    Installed    Available    Status         │
│  ─────────────────────────────────────────────────────────────────  │
│  elementor-pro             3.33.1       3.34.4       ⚠️ outdated    │
│  astra-addon               4.11.11      -            not in repo    │
│  ultimate-elementor        1.41.1       -            not in repo    │
│                                                                     │
│  💡 Upload new zips to wp-premium-plugins repo or update manually   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### If WP 2FA Not Installed

```
┌─────────────────────────────────────────────────────────────────────┐
│  🔐 SECURITY RECOMMENDATION                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  WP 2FA is NOT installed.                                           │
│                                                                     │
│  Two-Factor Authentication is recommended for all admin users.      │
│  Install: wp plugin install wp-2fa --activate                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### If Oxygen Builder Detected

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️  OXYGEN BUILDER WARNING                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Oxygen plugins detected:                                           │
│  • oxygen (4.9.1)                                                   │
│  • oxy-ninja (3.5.3)                                                │
│                                                                     │
│  ⛔ DO NOT update Oxygen without testing on staging first!          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Always End With This

```
┌─────────────────────────────────────────────────────────────────────┐
│  📋 MANUAL ACTION REQUIRED                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Clear Kinsta cache via dashboard (NOT via WP-CLI):                 │
│                                                                     │
│  🔗 https://my.kinsta.com/                                          │
│     → Sites → [site-name] → Tools → Clear cache                     │
│                                                                     │
│  ⚠️  Do NOT run: wp kinsta cache purge (causes performance issues)  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Slack Notifications (Optional)

After updates complete, WPM can automatically post a changelog summary to Slack.

### Setup

On each Kinsta server, add your Slack webhook URL to `~/.bashrc`:

```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T.../B.../xxx"
```

### How It Works

1. After `blz-wpm.sh` or `update-premium-plugins.sh update-all` finishes, the script checks for `SLACK_WEBHOOK_URL`
2. If set, it reads the **site-level** `CHANGELOG.md` at `$WP_ROOT/CHANGELOG.md` (outside `.claude/`)
3. Extracts today's entries and posts a summary to Slack via Block Kit

The notification is **completely optional** — if no webhook URL is set, or no changelog exists, it exits silently without affecting the update workflow.

### Standalone Usage

```bash
# Post today's changelog
bash .claude/scripts/notify-slack.sh

# Specific date
bash .claude/scripts/notify-slack.sh -d 2026-02-10

# Custom changelog file
bash .claude/scripts/notify-slack.sh -f /path/to/CHANGELOG.md

# Override site name
bash .claude/scripts/notify-slack.sh -s "mysite.com"

# Quiet mode (no stdout)
bash .claude/scripts/notify-slack.sh -q
```

### Flags

| Flag | Description |
|------|-------------|
| `-d DATE` | Target date (default: today) |
| `-f FILE` | Path to changelog file (default: `$WP_ROOT/CHANGELOG.md`) |
| `-s SITE` | Site name override (default: auto-detect via `wp option get siteurl`) |
| `-w URL` | Webhook URL override (default: `$SLACK_WEBHOOK_URL` env var) |
| `-q` | Quiet mode — suppress stdout |

---

### Status Icons Reference

| Icon | Meaning |
|------|---------|
| ✅ | Success / Complete |
| ⚠️ | Warning / Needs Attention |
| ⛔ | Do Not Proceed / Blocked |
| 🔒 | Maintenance Mode |
| ⬆️ | Core Update |
| 🗄️ | Database |
| 🔌 | Plugins |
| 💎 | Premium |
| 🎨 | Themes |
| 📋 | Documentation |
| 🔐 | Security |
| 🔗 | Link |
| 💡 | Tip/Suggestion |
