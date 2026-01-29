#!/bin/bash
#
# Update .claude folder from latest GitHub release
# Repository: blaze-commerce/claude-wpm
#
# Usage: bash .claude/scripts/update-claude-wpm.sh [-y|--yes]
#
# Options:
#   -y, --yes    Skip confirmation prompt (for non-interactive use)
#

set -e

REPO="blaze-commerce/claude-wpm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_DIR="/tmp/claude-wpm-update-$$"

# Parse arguments
AUTO_CONFIRM=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes)
            AUTO_CONFIRM=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-y|--yes]"
            exit 1
            ;;
    esac
done

echo "=== Claude WPM Updater ==="
echo ""

# Get current version from VERSION file first, then fallback to other methods
CURRENT_VERSION="unknown"
if [ -f "$CLAUDE_DIR/VERSION" ]; then
    CURRENT_VERSION=$(tr -d '[:space:]' < "$CLAUDE_DIR/VERSION")
elif [ -f "$CLAUDE_DIR/CLAUDE-BASE.md" ]; then
    CURRENT_VERSION=$(grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' "$CLAUDE_DIR/CLAUDE-BASE.md" 2>/dev/null | head -1 || echo "unknown")
fi
echo "Current version: $CURRENT_VERSION"

# Fetch latest release info from GitHub API
echo "Checking for latest release..."
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")

# Extract version and download URL (using grep -o with extended regex for compatibility)
LATEST_VERSION=$(echo "$RELEASE_INFO" | grep -oE '"tag_name":\s*"[^"]+"' | head -1 | sed 's/.*"tag_name":\s*"\([^"]*\)".*/\1/')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -oE '"browser_download_url":\s*"[^"]*claude-wpm-deploy[^"]*\.zip"' | head -1 | sed 's/.*"browser_download_url":\s*"\([^"]*\)".*/\1/')

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

# Confirm update (skip if -y flag is set)
if [ "$AUTO_CONFIRM" = false ]; then
    read -p "Update from $CURRENT_VERSION to $LATEST_VERSION? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Update cancelled."
        exit 0
    fi
else
    echo "Auto-confirming update (--yes flag set)"
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
echo "Run 'bash .claude/scripts/check-version.sh' to verify."
