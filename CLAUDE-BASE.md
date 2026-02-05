# Claude WPM - Base Configuration

Reusable instructions for Claude Code on WordPress/WooCommerce sites.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CLAUDE-BASE.md QUICK REFERENCE                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌───────────┐   │
│  │   SAFETY    │  │   SKILLS    │  │  COMMANDS   │  │  HOSTING  │   │
│  │   HOOKS     │  │ (Invoke)    │  │ (Workflow)  │  │  (Kinsta) │   │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────┬─────┘   │
│         │                │                │               │         │
│         ▼                ▼                ▼               ▼         │
│  • block-dangerous  /wordpress-master    /wpm         DO NOT use    │
│  • block-protected  /php-pro             └─ updates   wp kinsta     │
│    files            /security-auditor       core,     cache purge   │
│                     /database-admin         plugins,  via SSH       │
│                     /senior-architect       themes                  │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  PROTECTED: wp-includes/, wp-admin/, wp-config.php, parent themes   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## IMPORTANT: Changelog Workflow

**Update `CHANGELOG.md` when making changes to a site.** Document changes immediately after completing them (not before—you often don't know the full solution until you're done).

### What to Document

| Change Type | How to Document |
|-------------|-----------------|
| Bug fixes | **Always detailed** - Use Issue/Solution format below |
| New features/customizations | **Always detailed** - Describe what and why |
| Security patches | **Always detailed** - Note vulnerability and fix |
| Routine updates (`/wpm`) | **Condensed** - "Updated X plugins to latest versions" |

### Entry Formats

**For bug fixes** (the most valuable documentation):
```
### Fixed
- Brief description
  - Issue: What was the problem?
  - Solution: How was it fixed?
```

**For routine maintenance:**
```
### Changed
- Updated 12 plugins to latest versions via `/wpm`
- Updated WordPress core 6.4.2 → 6.4.3
```

### On /init

When running `/init`, if `CHANGELOG.md` does not exist in the project root, create it with:

```markdown
# Changelog

All notable changes to this website will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [YYYY-MM-DD]

### Added
- **CLAUDE.md** - Site-specific documentation for Claude Code
- **CHANGELOG.md** - Track all site changes, issues, and solutions
```

Replace `[YYYY-MM-DD]` with the current server date.

---

## Quick Checks

> **Setup Check:** If there is no `CLAUDE.md` file in the project root, remind the user to run `/init` to generate site-specific documentation.

> **Version Check:** At the start of new sessions, remind the user they can check for updates.

**Maintenance Commands** (copy & paste ready):

```bash
# Check for updates
bash .claude/scripts/check-version.sh
```

```bash
# Update to latest version
bash .claude/scripts/update-claude-wpm.sh -y
```

```bash
# Audit local files vs repo
bash .claude/scripts/audit-wpm.sh
```

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

### Required CLAUDE.md Structure

When running `/wpm`, ensure the site's `CLAUDE.md` includes these sections for full compatibility:

```markdown
# CLAUDE.md

## Site Overview
[Brief description of the site - type, theme, purpose]

## Directory Structure
[Generated by /init]

## Child Theme Customizations
| File | Purpose |
|------|---------|
[Document key custom files]

## Key Plugins
[Categorize important plugins: E-commerce, Payments, Shipping, SEO, etc.]

## Custom Endpoints / APIs
[Document any custom REST endpoints]

## Plugin Inventory

**Last updated:** [DATE] via `/wpm`

This section is auto-updated when running `/wpm`. New plugins are marked with `<- NEW`.

### Active Plugins

| Plugin | Version | Notes |
|--------|---------|-------|

### Inactive Plugins

| Plugin | Version | Notes |
|--------|---------|-------|

### Must-Use Plugins

| Plugin | Version | Notes |
|--------|---------|-------|
```

**Important:** The `## Plugin Inventory` section with the table format is required for `/wpm` to auto-update plugin lists.

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

### Required Security Plugins

**WP 2FA** (Two-Factor Authentication) is **required** on ALL Blaze Commerce sites.

- Plugin: https://wordpress.org/plugins/wp-2fa/
- Install: `wp plugin install wp-2fa --activate`

The `/wpm` command automatically checks for this plugin and displays a warning if missing.

### Premium Plugin Updates

After running `/wpm`:
1. Check the premium plugin reminder output
2. Verify all premium plugins are current
3. For Oxygen-related plugins, ALWAYS test on staging first
4. Update the site's CLAUDE.md with new versions
5. Check `.claude/cache/missing-premium-plugins.txt` for plugins not in repo

**Oxygen Builder Warning:** Never auto-update Oxygen, oxygen-woocommerce, oxy-ninja, or oxyultimate-woo without testing on staging first. These can break page layouts.

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

---

## Shell Script Development (For Claude)

**IMPORTANT:** All shell scripts in `.claude/scripts/` must pass `shellcheck` validation. The GitHub Actions security workflow (`security-check.yml`) runs shellcheck on every push and will **block releases** if validation fails.

### Before Creating or Modifying Shell Scripts

Always run shellcheck locally before committing:

```bash
shellcheck -e SC1091 -e SC2034 scripts/*.sh
```

### Common Shellcheck Issues to Avoid

| Code | Issue | Bad | Good |
|------|-------|-----|------|
| SC2001 | Use variable substitution instead of sed | `echo "$var" \| sed 's/^/  /'` | `while IFS= read -r line; do echo "  $line"; done <<< "$var"` |
| SC2002 | Useless cat - use input redirection | `cat file \| cmd` | `cmd < file` |
| SC2126 | Use grep -c instead of grep \| wc -l | `grep "x" \| wc -l` | `grep -c "x"` |
| SC2086 | Quote variables | `$var` | `"$var"` |
| SC2046 | Quote command substitution | `$(cmd)` | `"$(cmd)"` |
| SC2115 | Protect rm -rf from empty vars | `rm -rf "$dir"/*` | `rm -rf "${dir:?}"/*` |

### Excluded Checks

These are already excluded in the workflow:
- `SC1091` - Not following sourced files (external sources)
- `SC2034` - Unused variables (often used for colors/config)

### If Release Fails Due to Shellcheck

1. Check the GitHub Actions log for the specific error
2. Run `shellcheck scripts/your-script.sh` locally to see details
3. Fix the issue (don't just suppress warnings unless justified)
4. Commit the fix
5. Delete and recreate the tag:
   ```bash
   git tag -d vX.Y.Z
   git push origin :refs/tags/vX.Y.Z
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
