#!/bin/bash
#
# verify-deploy-zip.sh
# Verifies deploy zip contains correct files (QA check before release)
#
# Usage: .claude/scripts/verify-deploy-zip.sh <zip-file>
# Example: .claude/scripts/verify-deploy-zip.sh dist/claude-wpm-deploy-1.0.0.zip
#
# Exit codes:
#   0 = PASS (all checks passed)
#   1 = FAIL (missing required files or contains forbidden files)
#
# SOURCE OF TRUTH: This script reads required files from FILE_MAPPING.md
# The [WPM] labeled files in Complete File Inventory are used as the checklist.
# This ensures the verification always matches the auto-generated file mapping.
#

set -e

ZIP_FILE="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
FILE_MAPPING="$CLAUDE_DIR/FILE_MAPPING.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
ERRORS=0
WARNINGS=0

echo ""
echo -e "${BLUE}=== Deploy Zip Verification ===${NC}"
echo ""

# Check if zip file provided
if [ -z "$ZIP_FILE" ]; then
    echo -e "${RED}Error: No zip file specified${NC}"
    echo "Usage: $0 <zip-file>"
    exit 1
fi

# Check if file exists
if [ ! -f "$ZIP_FILE" ]; then
    echo -e "${RED}Error: File not found: $ZIP_FILE${NC}"
    exit 1
fi

# Check if FILE_MAPPING.md exists
if [ ! -f "$FILE_MAPPING" ]; then
    echo -e "${RED}Error: FILE_MAPPING.md not found at $FILE_MAPPING${NC}"
    echo "This file is required as the source of truth for verification."
    exit 1
fi

echo "Checking: $ZIP_FILE"
echo "Source of truth: FILE_MAPPING.md"
echo ""

# Get zip contents
ZIP_CONTENTS=$(unzip -l "$ZIP_FILE" | tail -n +4 | head -n -2 | awk '{print $4}')

# ============================================
# REQUIRED FILES (read from FILE_MAPPING.md)
# ============================================
echo -e "${YELLOW}[1/3] Checking required files...${NC}"
echo "       (Reading [WPM] files from FILE_MAPPING.md)"
echo ""

# Extract [WPM] files from FILE_MAPPING.md and convert to .claude/ paths
# Format in FILE_MAPPING.md: "- filename [WPM]"
REQUIRED_FILES=()
while IFS= read -r line; do
    # Remove "- " prefix and " [WPM]" suffix, then prepend .claude/
    file=$(echo "$line" | sed 's/^- //' | sed 's/ \[WPM\]$//')
    if [[ -n "$file" ]]; then
        REQUIRED_FILES+=(".claude/$file")
    fi
done < <(grep '\[WPM\]$' "$FILE_MAPPING" | grep -v '^\s*#')

for file in "${REQUIRED_FILES[@]}"; do
    if echo "$ZIP_CONTENTS" | grep -q "^${file}$"; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗ MISSING: $file${NC}"
        ((ERRORS++))
    fi
done

echo ""

# ============================================
# FORBIDDEN FILES (must NOT be present)
# ============================================
echo -e "${YELLOW}[2/3] Checking for forbidden files...${NC}"

FORBIDDEN_PATTERNS=(
    ".claude/qa/"
    ".claude/plans/"
    ".claude/cache/"
    ".claude/docs/"
    ".claude/.github/"
    ".claude/README.md"
    ".claude/CONTRIBUTING.md"
    ".claude/LICENSE"
    ".claude/FILE_MAPPING.md"
    ".claude/.gitignore"
    ".claude/settings.local.json"
    ".claude/scripts/create-deploy-zip.sh"
    ".claude/scripts/verify-deploy-zip.sh"
    "node_modules/"
    ".DS_Store"
)

for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    MATCHES=$(echo "$ZIP_CONTENTS" | grep "^${pattern}" || true)
    if [ -n "$MATCHES" ]; then
        echo -e "  ${RED}✗ FORBIDDEN: $pattern${NC}"
        echo "$MATCHES" | head -3 | sed 's/^/      /'
        COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')
        if [ "$COUNT" -gt 3 ]; then
            echo "      ... and $((COUNT-3)) more"
        fi
        ((ERRORS++))
    else
        echo -e "  ${GREEN}✓${NC} No $pattern files"
    fi
done

echo ""

# ============================================
# ZIP STRUCTURE CHECK
# ============================================
echo -e "${YELLOW}[3/3] Checking zip structure...${NC}"

# All files should be under .claude/
NON_CLAUDE_FILES=$(echo "$ZIP_CONTENTS" | grep -v "^\.claude" | grep -v "^$" || true)
if [ -n "$NON_CLAUDE_FILES" ]; then
    echo -e "  ${RED}✗ Files outside .claude/ directory:${NC}"
    echo "$NON_CLAUDE_FILES" | sed 's/^/      /'
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} All files under .claude/"
fi

# Check zip is not too large (warn if > 5MB)
ZIP_SIZE=$(stat -f%z "$ZIP_FILE" 2>/dev/null || stat --printf="%s" "$ZIP_FILE" 2>/dev/null)
ZIP_SIZE_MB=$((ZIP_SIZE / 1024 / 1024))
if [ "$ZIP_SIZE_MB" -gt 5 ]; then
    echo -e "  ${YELLOW}⚠ Warning: Zip is ${ZIP_SIZE_MB}MB (expected < 5MB)${NC}"
    ((WARNINGS++))
else
    echo -e "  ${GREEN}✓${NC} Zip size: ${ZIP_SIZE_MB}MB"
fi

echo ""

# ============================================
# SUMMARY
# ============================================
echo -e "${BLUE}=== Summary ===${NC}"
echo ""

FILE_COUNT=$(echo "$ZIP_CONTENTS" | grep -v "/$" | wc -l | tr -d ' ')
echo "Total files in zip: $FILE_COUNT"

if [ "$ERRORS" -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ ALL CHECKS PASSED${NC}"
    if [ "$WARNINGS" -gt 0 ]; then
        echo -e "${YELLOW}  ($WARNINGS warnings)${NC}"
    fi
    echo ""
    echo "Zip contents:"
    unzip -l "$ZIP_FILE" | tail -n +4 | head -n -2 | awk '{print "  " $4}'
    echo ""
    exit 0
else
    echo ""
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo -e "  $ERRORS errors, $WARNINGS warnings"
    echo ""
    echo "Please fix the issues above before releasing."
    exit 1
fi
