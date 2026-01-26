# Claude Code - WordPress Configuration

This file contains reusable instructions for Claude Code when working with WordPress projects using this configuration.

> **Setup Check:** If there is no `CLAUDE.md` file in the project root, remind the user to run `/init` to generate site-specific documentation.

## Configuration Sources

The `.claude/` setup in this project is based on these repositories:

| Component | Source Repository | What We Used |
|-----------|-------------------|--------------|
| Hooks | https://github.com/TheDecipherist/claude-code-mastery | PreToolUse hooks pattern for blocking dangerous commands and protected files |
| Skills | https://github.com/VoltAgent/awesome-claude-code-subagents | Skill prompts for wordpress-master, php-pro, security-auditor, database-administrator |

**Terminology note:** The VoltAgent repo calls them "subagents" but official Claude Code uses "skills" in `.claude/skills/`. We use the official convention.

### Auto-Check for Updates (Instructions for Claude)

**At the start of each new session**, Claude MUST automatically:

1. **Fetch and check both repositories above** for new or updated hooks/skills
2. **Compare** with currently installed items in `.claude/hooks/` and `.claude/skills/`
3. **Report** to the user if there are:
   - New hooks available that might be useful
   - New skills available (especially WordPress, PHP, security, database related)
   - Updates to existing hooks/skills we use
4. **Offer to install** any relevant new items

**Currently installed:**
- Hooks: `block-dangerous-commands.sh`, `block-protected-files.sh`
- Skills: `wordpress-master`, `php-pro`, `security-auditor`, `database-administrator`
- Commands: `wpm`

This check should be quick and silent if nothing new is found. Only notify the user if updates are available.

---

## Safety Hooks

This project has PreToolUse hooks in `.claude/hooks/` that **block dangerous operations**:

### Blocked Commands (`block-dangerous-commands.sh`)
- `rm -rf` on system/root directories
- Database destruction (`DROP DATABASE`, `wp db reset`)
- `wp kinsta cache purge` (causes performance issues)
- Fork bombs and disk operations

### Protected Files (`block-protected-files.sh`)
- `wp-includes/` - WordPress core
- `wp-admin/` - WordPress core
- `wp-config.php` - Contains DB credentials
- `blocksy/` parent theme - Use child theme instead
- `.htaccess`, `.htpasswd` - Server config

If you need to modify protected files, do it manually via SSH or SFTP.

---

## Skills (Specialists)

Located in `.claude/skills/`. Invoke manually when you need focused expertise:

| Command | Specialist | Use For |
|---------|------------|---------|
| `/wordpress-master` | WordPress/WooCommerce expert | Theme issues, plugin conflicts, WP optimization |
| `/php-pro` | PHP developer | PHP code review, debugging, modern PHP patterns |
| `/security-auditor` | Security specialist | Code review, vulnerability checks, hardening |
| `/database-administrator` | MySQL/DB expert | Query optimization, cleanup, performance |

**How to use:**
```
/wordpress-master why is my site loading slowly?
/security-auditor review this plugin code for vulnerabilities
/database-administrator help me clean up wp_options bloat
```

Or naturally: "Ask the wordpress-master to check this"

---

## Commands

Located in `.claude/commands/`. Custom workflow automation:

| Command | Purpose |
|---------|---------|
| `/wpm` | WordPress Maintenance - updates core, plugins, themes in correct order |

**Update order followed by `/wpm`:**
1. WordPress core -> 2. Database -> 3. Free plugins -> 4. Premium plugins -> 5. Themes -> 6. (Manual cache clear reminder)

**Direct SSH alternative:** `.claude/scripts/blz-wpm.sh`

---

## Premium Plugins

Premium plugins cannot be updated via `wp plugin update --all` (requires license validation).

**Solution:** Private Git repository at `git@github.com:blaze-commerce/wp-premium-plugins.git`

**Source:** https://www.gpltimes.com/

**Managed plugins:**
- elementor-pro
- gp-premium
- perfmatters
- woo-checkout-field-editor-pro
- admin-site-enhancements-pro
- wp-mail-smtp-pro
- surerank-pro

**Update script:** `.claude/scripts/update-premium-plugins.sh`

```bash
# List available premium plugins and versions
.claude/scripts/update-premium-plugins.sh list

# Update all installed premium plugins
.claude/scripts/update-premium-plugins.sh update-all

# Update specific plugin
.claude/scripts/update-premium-plugins.sh update elementor-pro
```

**Safety:** If a plugin has no zip in the repo, it's skipped - existing installation remains untouched.

**Adding new plugin versions to repo:** Upload zip to wp-premium-plugins repo, then run update on sites.

---

## WordPress Best Practices

### Do Not Modify
- `wp-includes/` - WordPress core
- `wp-admin/` - WordPress core
- Parent theme directory - Updates will overwrite
- Plugin files directly - Use hooks instead

### Safe to Modify
- Child theme files
- Code Snippets via admin panel
- `wp-config.php` (carefully, manually)

### Where to Find Custom Code
1. Check Code Snippets plugin first (`code-snippets-pro` or `wpcode-premium`)
2. Check child theme `functions.php` and `includes/`
3. Check `insert-headers-and-footers` plugin
4. Check individual plugin settings

### WooCommerce Templates
Child theme overrides are in `wp-content/themes/[child-theme]/woocommerce/`. Check template version compatibility when WooCommerce updates.

---

## Kinsta Hosting

**IMPORTANT: DO NOT purge Kinsta cache via SSH/WP-CLI** - it causes performance issues.

```bash
# DO NOT USE:
# wp kinsta cache purge
```

**Always purge cache manually via Kinsta dashboard:**
https://my.kinsta.com/ -> Sites -> Tools -> Clear cache

### Clear Caches After Changes
1. Kinsta cache (via dashboard only - NOT via SSH)
2. Performance plugin cache (Perfmatters, WP Rocket, etc.)
3. Browser cache

---

## Database Access

- Credentials in `wp-config.php`
- Table prefix: Check `$table_prefix` in wp-config.php (usually `wp_`)
