#!/bin/bash
#
# create-deploy-zip.sh
# Creates a clean deployment zip WITHOUT the qa/ folder
#
# Usage: .claude/scripts/create-deploy-zip.sh [version]
# Example: .claude/scripts/create-deploy-zip.sh 1.2.0
#

set -e

VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
CLAUDE_DIR="$REPO_ROOT/.claude"
OUTPUT_DIR="$REPO_ROOT/dist"
OUTPUT_FILE="claude-wpm-deploy-${VERSION}.zip"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Creating deployment zip...${NC}"
echo "Version: $VERSION"
echo "Source: $CLAUDE_DIR"

mkdir -p "$OUTPUT_DIR"
cd "$REPO_ROOT"

zip -r "$OUTPUT_DIR/$OUTPUT_FILE" .claude \
    -x ".claude/qa/*" \
    -x ".claude/cache/*" \
    -x ".claude/plans/*" \
    -x ".claude/settings.local.json" \
    -x "*.DS_Store" \
    -x "*.swp" \
    -x "*.swo"

echo ""
echo -e "${GREEN}Success!${NC}"
echo "Created: $OUTPUT_DIR/$OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "  1. Go to GitHub Releases"
echo "  2. Create new release with tag v$VERSION"
echo "  3. Upload: $OUTPUT_DIR/$OUTPUT_FILE"
