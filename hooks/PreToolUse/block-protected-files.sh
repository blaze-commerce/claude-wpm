#!/bin/bash

# ------------------------------------------------------
# block-protected-files.sh
# PreToolUse hook to block modifying protected WordPress files
# Exit code 2 = BLOCK the operation
# Exit code 0 = ALLOW the operation
# From Blaze Commerce – maintained by jarutosurano
# ------------------------------------------------------

# Read the JSON input from Claude Code
INPUT=$(cat)

# Get the tool name
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only check file modification tools
case "$TOOL" in
    Edit|Write|NotebookEdit)
        ;;
    *)
        exit 0
        ;;
esac

# Get the file path being modified
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# If no file path, allow (shouldn't happen)
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Protected paths - block modifications to these
PROTECTED_PATTERNS=(
    # WordPress core
    "wp-includes/"
    "wp-admin/"

    # WordPress config (contains DB credentials)
    "wp-config.php"
    "wp-config-sample.php"

    # Parent theme (will be overwritten on updates)
    "/themes/blocksy/"

    # Plugin files (should use hooks, not direct edits)
    # Uncomment if you want to protect all plugins too:
    # "/plugins/"

    # Sensitive files
    ".htaccess"
    ".htpasswd"
    "php.ini"
    ".user.ini"
)

# Check each protected pattern
for PATTERN in "${PROTECTED_PATTERNS[@]}"; do
    if echo "$FILE_PATH" | grep -q "$PATTERN"; then
        echo "BLOCKED: Cannot modify protected WordPress file"
        echo "File: $FILE_PATH"
        echo "Pattern matched: $PATTERN"
        echo ""
        echo "Protected files include:"
        echo "  - wp-includes/ (WordPress core)"
        echo "  - wp-admin/ (WordPress core)"
        echo "  - wp-config.php (contains credentials)"
        echo "  - blocksy/ parent theme (use child theme instead)"
        echo ""
        echo "If you really need to modify this, do it manually."
        exit 2
    fi
done

# Allow the modification
exit 0
