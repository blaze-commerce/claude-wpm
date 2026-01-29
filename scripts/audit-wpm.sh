#!/bin/bash
#
# audit-wpm.sh
# Compare local .claude files with latest WPM repo
# Shows what's current, missing, or extra
#
# Usage: bash .claude/scripts/audit-wpm.sh
#

REPO="blaze-commerce/claude-wpm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              WPM File Audit - Local vs Repo                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get local files (excluding cache, settings.local.json)
echo -e "${CYAN}Scanning local .claude folder...${NC}"
LOCAL_FILES=$(find "$CLAUDE_DIR" -type f \
    -not -path "*/cache/*" \
    -not -path "*/.git/*" \
    -not -name "settings.local.json" \
    -not -name ".DS_Store" \
    -not -name "*.swp" \
    2>/dev/null | \
    sed "s|$CLAUDE_DIR/||" | sort)

# Fetch FILE_MAPPING.md from GitHub to get expected [WPM] files
echo -e "${CYAN}Fetching latest file mapping from GitHub...${NC}"
FILE_MAPPING=$(curl -s "https://raw.githubusercontent.com/$REPO/main/FILE_MAPPING.md" 2>/dev/null)

if [ -z "$FILE_MAPPING" ]; then
    echo -e "${RED}Error: Could not fetch FILE_MAPPING.md from GitHub${NC}"
    echo "Check your internet connection or try:"
    echo "  https://github.com/$REPO/blob/main/FILE_MAPPING.md"
    exit 1
fi

# Extract [WPM] files from FILE_MAPPING.md (these should be on Kinsta)
REPO_WPM_FILES=$(echo "$FILE_MAPPING" | grep '\[WPM\]$' | sed 's/^- //' | sed 's/ \[WPM\]$//' | sort)

# Also get [REPO] files for reference
REPO_ONLY_FILES=$(echo "$FILE_MAPPING" | grep '\[REPO\]$' | sed 's/^- //' | sed 's/ \[REPO\]$//' | sort)

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}[WPM] Files - Should be on Kinsta${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

MISSING=0
PRESENT=0

while IFS= read -r file; do
    if [ -z "$file" ]; then continue; fi

    if echo "$LOCAL_FILES" | grep -q "^${file}$"; then
        echo -e "  ${GREEN}✓${NC} $file"
        ((PRESENT++))
    else
        echo -e "  ${RED}✗ MISSING:${NC} $file"
        ((MISSING++))
    fi
done <<< "$REPO_WPM_FILES"

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Extra Local Files - Not in WPM repo${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

EXTRA=0
while IFS= read -r file; do
    if [ -z "$file" ]; then continue; fi

    # Check if file is in WPM list
    if echo "$REPO_WPM_FILES" | grep -q "^${file}$"; then
        continue
    fi

    # Check if file is a known [REPO] file (expected to not be there, but might be)
    if echo "$REPO_ONLY_FILES" | grep -q "^${file}$"; then
        echo -e "  ${YELLOW}?${NC} $file ${YELLOW}(repo-only file, can be removed)${NC}"
    else
        echo -e "  ${CYAN}+${NC} $file ${CYAN}(custom/local file)${NC}"
    fi
    ((EXTRA++))
done <<< "$LOCAL_FILES"

if [ "$EXTRA" -eq 0 ]; then
    echo -e "  ${GREEN}None - clean installation${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  WPM files present:  ${GREEN}$PRESENT${NC}"
echo -e "  WPM files missing:  ${RED}$MISSING${NC}"
echo -e "  Extra local files:  ${YELLOW}$EXTRA${NC}"
echo ""

if [ "$MISSING" -gt 0 ]; then
    echo -e "${YELLOW}Recommendation:${NC} Run the update script to get missing files:"
    echo -e "  ${CYAN}bash .claude/scripts/update-claude-wpm.sh${NC}"
    echo ""
fi

if [ "$MISSING" -eq 0 ] && [ "$EXTRA" -eq 0 ]; then
    echo -e "${GREEN}Your .claude folder matches the WPM repo perfectly!${NC}"
    echo ""
fi

# Show version info
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Version Info${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Try to get local version (check VERSION file first, then fallback)
LOCAL_VERSION="unknown"
if [ -f "$CLAUDE_DIR/VERSION" ]; then
    LOCAL_VERSION=$(tr -d '[:space:]' < "$CLAUDE_DIR/VERSION")
elif [ -f "$CLAUDE_DIR/CLAUDE-BASE.md" ]; then
    LOCAL_VERSION=$(grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' "$CLAUDE_DIR/CLAUDE-BASE.md" 2>/dev/null | head -1 || echo "unknown")
fi

# Get latest release version
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null)
LATEST_VERSION=$(echo "$RELEASE_INFO" | grep -oE '"tag_name":\s*"[^"]+"' | head -1 | sed 's/.*"tag_name":\s*"\([^"]*\)".*/\1/' || echo "unknown")

echo -e "  Local version:   ${YELLOW}$LOCAL_VERSION${NC}"
echo -e "  Latest release:  ${GREEN}$LATEST_VERSION${NC}"
echo ""

if [ "$LOCAL_VERSION" != "$LATEST_VERSION" ] && [ "$LOCAL_VERSION" != "unknown" ]; then
    echo -e "${YELLOW}Update available!${NC} Run:"
    echo -e "  ${CYAN}bash .claude/scripts/update-claude-wpm.sh${NC}"
    echo ""
fi
