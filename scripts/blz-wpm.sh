#!/bin/bash

# ------------------------------------------------------
# blz-wpm.sh
# This is a script created for updating WordPress core files,
# plugins, and themes via SSH.
# From Blaze Commerce – maintained by jarutosurano
# ------------------------------------------------------

# Auto-detect script directory for sibling script calls
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Error trap — send Slack alert on failure, then ensure maintenance mode is disabled
on_error() {
    local exit_code=$?
    local line_no=$1
    if [ -n "${SLACK_WEBHOOK_URL:-}" ]; then
        bash "$SCRIPT_DIR/notify-slack.sh" -q -e "blz-wpm.sh failed at line ${line_no} (exit code ${exit_code})"
    fi
    # Safety: always try to disable maintenance mode on failure
    disable_maintenance_mode 2>/dev/null || true
}
trap 'on_error ${LINENO}' ERR

# Track which maintenance method is used
MAINTENANCE_METHOD=""

# Custom maintenance.php content
MAINTENANCE_PHP='<?php
header('\''HTTP/1.1 503 Service Unavailable'\'');
header('\''Status: 503 Service Unavailable'\'');
header('\''Retry-After: 3600'\'');
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
            font-family: -apple-system, BlinkMacSystemFont, '\''Segoe UI'\'', Roboto, sans-serif;
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
        <h1>We'\''ll be back soon.</h1>
        <p>This site is undergoing maintenance for an extended period today.<br>Thanks for your patience.</p>
    </div>
</body>
</html>'

# ------------------------------------------------------
# Enable Maintenance Mode
# Priority: 1) Woo Site Visibility  2) ASE Pro  3) Custom .maintenance
# ------------------------------------------------------
enable_maintenance_mode() {
    echo "----------------------------------------"
    echo "Enabling Maintenance Mode..."
    echo "----------------------------------------"

    # Priority 1: WooCommerce Site Visibility (Coming Soon)
    if wp plugin is-active woocommerce 2>/dev/null; then
        echo "WooCommerce detected - using Site Visibility (Coming Soon)"
        wp option update woocommerce_coming_soon "yes" --autoload=yes 2>/dev/null
        MAINTENANCE_METHOD="woo"
        echo "✓ WooCommerce Coming Soon mode enabled"

    # Priority 2: ASE Pro maintenance mode
    elif wp plugin is-active admin-site-enhancements-pro 2>/dev/null; then
        echo "ASE Pro detected - using ASE maintenance mode"
        wp option patch update admin_site_enhancements maintenance_mode 1
        MAINTENANCE_METHOD="ase"
        echo "✓ ASE Pro maintenance mode enabled"

    # Priority 3: Custom .maintenance fallback
    else
        echo "No WooCommerce or ASE Pro - using custom maintenance mode"
        echo ""
        echo "⚠️  WARNING: Custom maintenance mode may not work perfectly with"
        echo "   CDN caching (cached pages may still be visible). For reliable"
        echo "   maintenance mode, use a WooCommerce or ASE Pro site."
        echo ""

        # Create maintenance.php if it doesn't exist (relative to WP root)
        if [ ! -f "wp-content/maintenance.php" ]; then
            echo "Creating wp-content/maintenance.php..."
            echo "$MAINTENANCE_PHP" > wp-content/maintenance.php
        fi

        # Enable maintenance mode by creating .maintenance file
        # shellcheck disable=SC2016
        echo '<?php $upgrading = time(); ?>' > .maintenance
        MAINTENANCE_METHOD="custom"
        echo "✓ Custom maintenance mode enabled"
    fi
    echo ""
}

# ------------------------------------------------------
# Disable Maintenance Mode
# Uses the same method that was used to enable it
# ------------------------------------------------------
disable_maintenance_mode() {
    echo "----------------------------------------"
    echo "Disabling Maintenance Mode..."
    echo "----------------------------------------"

    if [ "$MAINTENANCE_METHOD" = "woo" ]; then
        wp option update woocommerce_coming_soon "no" 2>/dev/null
        echo "✓ WooCommerce Coming Soon mode disabled (site is Live)"
    elif [ "$MAINTENANCE_METHOD" = "ase" ]; then
        wp option patch update admin_site_enhancements maintenance_mode 0
        echo "✓ ASE Pro maintenance mode disabled"
    elif [ "$MAINTENANCE_METHOD" = "custom" ]; then
        rm -f .maintenance
        echo "✓ Custom maintenance mode disabled (maintenance.php kept for future use)"
    else
        # Fallback: try to disable all methods just in case
        echo "Disabling all maintenance modes (safety fallback)..."
        wp option update woocommerce_coming_soon "no" 2>/dev/null
        wp plugin is-active admin-site-enhancements-pro 2>/dev/null && \
            wp option patch update admin_site_enhancements maintenance_mode 0
        rm -f .maintenance
        echo "✓ Maintenance mode disabled"
    fi
    echo ""
}

# ------------------------------------------------------
# Main Script
# ------------------------------------------------------

echo "========================================"
echo "Starting WordPress Maintenance Updates"
echo "========================================"
echo ""

# Step 0: Enable Maintenance Mode (REQUIRED)
enable_maintenance_mode

# Step 1: Update WordPress core
echo "----------------------------------------"
echo "Updating WordPress core..."
echo "----------------------------------------"
wp core update
wp core update-db
echo ""

# Step 2: Update plugins
echo "----------------------------------------"
echo "Updating plugins..."
echo "----------------------------------------"
wp plugin update --all
echo ""

# Step 3: Update themes
echo "----------------------------------------"
echo "Updating themes..."
echo "----------------------------------------"
wp theme update --all
echo ""

# Step 4: Disable Maintenance Mode (REQUIRED)
disable_maintenance_mode

# NOTE: Do NOT purge Kinsta cache via SSH/WP-CLI - it causes performance issues
# Purge cache manually via Kinsta dashboard instead

# Visual Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                         ✅ UPDATE COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "┌─────────────────────────────────────────────────────────────────────┐"
echo "│                        UPDATE SUMMARY                               │"
echo "├─────────────────────────────────────────────────────────────────────┤"
echo "│                                                                     │"
if [ "$MAINTENANCE_METHOD" = "woo" ]; then
    echo "│  🔒 Maintenance Mode    Woo Coming Soon enabled → disabled          │"
elif [ "$MAINTENANCE_METHOD" = "ase" ]; then
    echo "│  🔒 Maintenance Mode    ASE Pro enabled → disabled                  │"
else
    echo "│  🔒 Maintenance Mode    Custom (.maintenance) enabled → disabled    │"
fi
echo "│                                                                     │"
echo "│  ⬆️  WordPress Core      Updated (check output above)               │"
echo "│  🗄️  Database            Updated                                    │"
echo "│  🔌 Free Plugins        Updated (check output above)               │"
echo "│  🎨 Themes              Updated (check output above)               │"
echo "│                                                                     │"
echo "│  ⚠️  Premium plugins require separate update via Claude /wpm        │"
echo "│                                                                     │"
echo "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────────────────┐"
echo "│  📋 MANUAL ACTION REQUIRED                                          │"
echo "├─────────────────────────────────────────────────────────────────────┤"
echo "│                                                                     │"
echo "│  1. Verify site is accessible (incognito browser window)           │"
echo "│                                                                     │"
echo "│  2. Clear Kinsta cache via dashboard (NOT via WP-CLI):             │"
echo "│                                                                     │"
echo "│     🔗 https://my.kinsta.com/                                       │"
echo "│        → Sites → [site-name] → Tools → Clear cache                 │"
echo "│                                                                     │"
echo "│     ⛔ Do NOT run: wp kinsta cache purge                            │"
echo "│        (causes performance issues)                                 │"
echo "│                                                                     │"
echo "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Slack notification (optional — requires SLACK_WEBHOOK_URL)
if [ -n "${SLACK_WEBHOOK_URL:-}" ]; then
    bash "$SCRIPT_DIR/notify-slack.sh" -q
fi
