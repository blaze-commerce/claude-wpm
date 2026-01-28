#!/bin/bash
#
# check-version.sh
# Check if a newer version of claude-wpm is available
#
# Usage: bash .claude/scripts/check-version.sh
#

REPO="blaze-commerce/claude-wpm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}=== Claude WPM Version Check ===${NC}"
echo ""

# Try to get current version from README.md
CURRENT_VERSION="unknown"
if [ -f "$CLAUDE_DIR/README.md" ]; then
    # Look for version pattern like v1.0.0 or Version: 1.0.0
    CURRENT_VERSION=$(grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' "$CLAUDE_DIR/README.md" 2>/dev/null | head -1 || echo "unknown")
fi

# If still unknown, check for VERSION file
if [ "$CURRENT_VERSION" = "unknown" ] && [ -f "$CLAUDE_DIR/VERSION" ]; then
    CURRENT_VERSION=$(cat "$CLAUDE_DIR/VERSION" | tr -d '[:space:]')
fi

echo -e "Current version: ${YELLOW}${CURRENT_VERSION}${NC}"

# Fetch latest release from GitHub API
echo "Checking GitHub for latest release..."
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null)

if [ -z "$RELEASE_INFO" ] || echo "$RELEASE_INFO" | grep -q "Not Found"; then
    echo -e "${YELLOW}Could not fetch release info from GitHub${NC}"
    echo "Check manually: https://github.com/$REPO/releases"
    exit 1
fi

# Extract latest version
LATEST_VERSION=$(echo "$RELEASE_INFO" | grep -oE '"tag_name":\s*"[^"]+"' | head -1 | sed 's/.*"tag_name":\s*"\([^"]*\)".*/\1/')
PUBLISHED_AT=$(echo "$RELEASE_INFO" | grep -oE '"published_at":\s*"[^"]+"' | head -1 | sed 's/.*"published_at":\s*"\([^"]*\)".*/\1/' | cut -d'T' -f1)

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${YELLOW}Could not parse latest version${NC}"
    echo "Check manually: https://github.com/$REPO/releases"
    exit 1
fi

echo -e "Latest version:  ${GREEN}${LATEST_VERSION}${NC} (released: $PUBLISHED_AT)"
echo ""

# Compare versions
if [ "$CURRENT_VERSION" = "unknown" ]; then
    echo -e "${YELLOW}Unable to determine current version.${NC}"
    echo ""
    echo "To update, run:"
    echo -e "  ${BLUE}bash .claude/scripts/update-claude-wpm.sh${NC}"
    echo ""
    echo "Or download manually from:"
    echo "  https://github.com/$REPO/releases/latest"
elif [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo -e "${GREEN}You are up to date!${NC}"
else
    echo -e "${YELLOW}Update available!${NC}"
    echo ""
    echo "To update from $CURRENT_VERSION to $LATEST_VERSION, run:"
    echo -e "  ${BLUE}bash .claude/scripts/update-claude-wpm.sh${NC}"
    echo ""
    echo "Or download manually from:"
    echo "  https://github.com/$REPO/releases/latest/download/claude-wpm-deploy.zip"
fi

echo ""
