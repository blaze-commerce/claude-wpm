#!/bin/bash
#
# Update .claude folder from latest GitHub release
# Repository: blaze-commerce/claude-wpm
#
# Usage: bash .claude/scripts/update-claude-wpm.sh
#

set -e

REPO="blaze-commerce/claude-wpm"
CLAUDE_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
SITE_ROOT="$(dirname "$CLAUDE_DIR")"
TEMP_DIR="/tmp/claude-wpm-update-$$"

echo "=== Claude WPM Updater ==="
echo ""

# Get current version (if exists)
CURRENT_VERSION="unknown"
if [ -f "$CLAUDE_DIR/README.md" ]; then
    CURRENT_VERSION=$(grep -oP 'v\d+\.\d+\.\d+' "$CLAUDE_DIR/README.md" | head -1 || echo "unknown")
fi
echo "Current version: $CURRENT_VERSION"

# Fetch latest release info from GitHub API
echo "Checking for latest release..."
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")

# Extract version and download URL
LATEST_VERSION=$(echo "$RELEASE_INFO" | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -oP '"browser_download_url":\s*"\K[^"]+deploy[^"]*\.zip' | head -1)

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch latest release info"
    echo "Check: https://github.com/$REPO/releases"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Compare versions
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo ""
    echo "Already up to date!"
    exit 0
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: No deploy zip found in release assets"
    echo "Expected: claude-wpm-deploy-*.zip"
    exit 1
fi

echo "Download URL: $DOWNLOAD_URL"
echo ""

# Confirm update
read -p "Update from $CURRENT_VERSION to $LATEST_VERSION? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Update cancelled."
    exit 0
fi

# Create temp directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download release
echo "Downloading..."
curl -sL "$DOWNLOAD_URL" -o release.zip

# Extract
echo "Extracting..."
unzip -q release.zip

# Verify extraction
if [ ! -d ".claude" ]; then
    echo "Error: .claude folder not found in archive"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Update using rsync (preserves any local customizations if needed)
echo "Updating .claude folder..."
rsync -av --delete "$TEMP_DIR/.claude/" "$CLAUDE_DIR/"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== Update Complete ==="
echo "Updated to: $LATEST_VERSION"
echo ""
echo "Changes:"
echo "  - New skills, hooks, and commands installed"
echo "  - Check .claude/README.md for release notes"
