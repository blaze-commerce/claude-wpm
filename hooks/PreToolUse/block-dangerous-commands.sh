#!/bin/bash

# ------------------------------------------------------
# block-dangerous-commands.sh
# PreToolUse hook to block destructive bash commands
# Exit code 2 = BLOCK the operation
# Exit code 0 = ALLOW the operation
# From Blaze Commerce – maintained by jarutosurano
# ------------------------------------------------------

# Read the JSON input from Claude Code
INPUT=$(cat)

# Get the tool name
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only check Bash commands
if [ "$TOOL" != "Bash" ]; then
    exit 0
fi

# Get the command being run
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# List of dangerous patterns to block
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf /*"
    "rm -rf ."
    "rm -rf .."
    "rm -rf ~"
    "rm -rf /www"
    "rm -rf /var"
    "rm -rf /etc"
    "rm -rf /home"
    "> /dev/sda"
    "mkfs."
    "dd if="
    ":(){:|:&};:"
    "chmod -R 777 /"
    "chown -R"
    "wp db reset"
    "wp db drop"
    "DROP DATABASE"
    "DROP TABLE"
    "TRUNCATE TABLE"
    "DELETE FROM wp_"
    "wp site empty"
    "wp plugin delete --all"
    "wp theme delete --all"
    "wp kinsta cache purge"
)

# Check each dangerous pattern
for PATTERN in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qi "$PATTERN"; then
        echo "BLOCKED: Dangerous command detected"
        echo "Pattern matched: $PATTERN"
        echo "Command: $COMMAND"
        echo ""
        echo "If you really need to run this, do it manually via SSH."
        exit 2
    fi
done

# Allow the command
exit 0
