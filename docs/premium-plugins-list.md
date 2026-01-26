# Premium Plugins Master List

This document tracks all premium plugins used across Blaze Commerce sites.

## Currently in Repository

These plugins have zips in `wp-premium-plugins` repo:

| Plugin Slug | Source | Notes |
|-------------|--------|-------|
| elementor-pro | gpltimes.com | Page builder |
| gp-premium | gpltimes.com | GeneratePress premium |
| perfmatters | gpltimes.com | Performance |
| woo-checkout-field-editor-pro | gpltimes.com | WooCommerce checkout |
| admin-site-enhancements-pro | gpltimes.com | Admin enhancements |
| wp-mail-smtp-pro | gpltimes.com | Email delivery |
| surerank-pro | gpltimes.com | SEO |

## Known Premium Plugin Patterns

The update script detects these patterns as premium plugins:

- `*-pro` (e.g., elementor-pro, wpforms-pro)
- `*-premium` (e.g., gp-premium)
- Specific slugs: perfmatters, gravityforms, wp-rocket, etc.

## Adding New Premium Plugins

When `/wpm` detects a premium plugin not in the repo:

1. Check `.claude/cache/missing-premium-plugins.txt` for the list
2. Download from gpltimes.com (or vendor if licensed)
3. Add to `wp-premium-plugins` repo:
   ```
   plugins/<slug>/<slug>-<version>.zip
   ```
4. Commit and push
5. Update this list

## Sites Using Premium Plugins

| Site | Premium Plugins |
|------|-----------------|
| birdbustanet | elementor-pro, gp-premium, perfmatters, admin-site-enhancements-pro, wp-mail-smtp-pro, surerank-pro, woo-checkout-field-editor-pro |

*Update this table when adding new sites*
