# Premium Plugins

This is a site-specific file. Update with your site's premium plugins.

## Site Premium Plugins

| Plugin | Version | Vendor | Notes |
|--------|---------|--------|-------|
| elementor-pro | x.x.x | gpltimes.com | Page builder |
| gp-premium | x.x.x | gpltimes.com | GeneratePress premium |
| perfmatters | x.x.x | gpltimes.com | Performance |
| admin-site-enhancements-pro | x.x.x | gpltimes.com | Admin enhancements |
| wp-mail-smtp-pro | x.x.x | gpltimes.com | Email delivery |

## Update Warnings

> ⚠️ List any plugins that should NOT be auto-updated here.

**Example warnings:**
- `oxygen` - Test on staging before updating (page builder, can break layouts)
- `oxygen-woocommerce` - Same as above
- `gravityforms` - Check form compatibility after update

## Plugins NOT in Update Repo

These premium plugins are installed but not managed by `update-premium-plugins.sh`:

| Plugin | Version | Reason |
|--------|---------|--------|
| oxygen | 4.9.1 | Not in repo - update manually |

## Checklist Template

After `/wpm`, verify:
- [ ] All premium plugins updated
- [ ] Oxygen plugins tested on staging (if applicable)
- [ ] CLAUDE.md inventory updated
- [ ] Site functionality verified

---

## Adding Plugins to the Repo

When a premium plugin is missing from the repo:

1. Check `.claude/cache/missing-premium-plugins.txt` for the list
2. Download from gpltimes.com (or vendor if licensed)
3. Add to `wp-premium-plugins` repo:
   ```
   plugins/<slug>/<slug>-<version>.zip
   ```
4. Commit and push
5. Update this file with the new plugin

## Known Premium Plugin Patterns

The update script detects these patterns as premium plugins:

- `*-pro` (e.g., elementor-pro, wpforms-pro)
- `*-premium` (e.g., gp-premium)
- Specific slugs: perfmatters, gravityforms, wp-rocket, etc.

See `scripts/update-premium-plugins.sh` for the full pattern list.
