#!/bin/bash

# ------------------------------------------------------
# blz-wpm.sh
# This is a script created for updating WordPress core files,
# plugins, and themes via SSH.
# From Blaze Commerce – maintained by jarutosurano
# ------------------------------------------------------

echo "----------------------------------------"
echo "Starting WordPress Maintenance Updates"
echo "----------------------------------------"

echo "Updating WordPress core..."
wp core update
wp core update-db

echo "Updating plugins..."
wp plugin update --all

echo "Updating themes..."
wp theme update --all

# NOTE: Do NOT purge Kinsta cache via SSH/WP-CLI - it causes performance issues
# Purge cache manually via Kinsta dashboard instead
# echo "Purging Kinsta cache..."
# wp kinsta cache purge

echo "----------------------------------------"
echo "All updates completed!"
echo "----------------------------------------"
echo ""
echo "REMINDER: Manually purge cache via Kinsta dashboard"
echo "https://my.kinsta.com/ -> Sites -> Tools -> Clear cache"
echo "----------------------------------------"
