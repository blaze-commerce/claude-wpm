#!/bin/bash

# ------------------------------------------------------
# notify-slack.sh
# Post changelog summary to Slack via webhook
# From Blaze Commerce – maintained by jarutosurano
#
# Reads the SITE-LEVEL CHANGELOG.md (at WP root, outside .claude/)
# and posts a summary of today's entries to Slack.
#
# Usage:
#   bash notify-slack.sh                     # Auto-detect everything
#   bash notify-slack.sh -d 2026-02-10       # Specific date
#   bash notify-slack.sh -f /path/to/CL.md   # Specific changelog
#   bash notify-slack.sh -s "mysite.com"      # Override site name
#   bash notify-slack.sh -w "https://..."     # Override webhook URL
#   bash notify-slack.sh -q                   # Quiet mode (no stdout)
#
# Environment:
#   SLACK_WEBHOOK_URL  - Slack incoming webhook URL (required)
#   WP_ROOT            - WordPress root directory (auto-detected)
# ------------------------------------------------------

set -euo pipefail

# Auto-detect paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WP_ROOT="${WP_ROOT:-$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)}"

# Defaults
TARGET_DATE="$(date '+%Y-%m-%d')"
CHANGELOG_FILE="$WP_ROOT/CHANGELOG.md"
SITE_NAME=""
WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
QUIET=false

# WPM version (read from VERSION file if available)
WPM_VERSION=""
if [ -f "$SCRIPT_DIR/../VERSION" ]; then
    WPM_VERSION="$(cat "$SCRIPT_DIR/../VERSION" 2>/dev/null | tr -d '[:space:]')"
fi

# Parse flags
while getopts "d:f:s:w:q" opt; do
    case $opt in
        d) TARGET_DATE="$OPTARG" ;;
        f) CHANGELOG_FILE="$OPTARG" ;;
        s) SITE_NAME="$OPTARG" ;;
        w) WEBHOOK_URL="$OPTARG" ;;
        q) QUIET=true ;;
        *) exit 0 ;;
    esac
done

# Logging (respects quiet mode)
log() {
    if [ "$QUIET" = false ]; then
        echo "$1"
    fi
}

# ------------------------------------------------------
# Graceful exit: no webhook or no changelog = silent success
# ------------------------------------------------------
if [ -z "$WEBHOOK_URL" ]; then
    log "[slack] No SLACK_WEBHOOK_URL set — skipping notification"
    exit 0
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    log "[slack] No changelog found at $CHANGELOG_FILE — skipping"
    exit 0
fi

# ------------------------------------------------------
# Auto-detect site name
# ------------------------------------------------------
if [ -z "$SITE_NAME" ]; then
    # Try wp option get siteurl
    if command -v wp &> /dev/null; then
        SITE_NAME="$(wp option get siteurl 2>/dev/null | sed 's|https\?://||' | sed 's|/.*||')" || true
    fi
    # Fallback: hostname
    if [ -z "$SITE_NAME" ]; then
        SITE_NAME="$(hostname -f 2>/dev/null || hostname)"
    fi
fi

# ------------------------------------------------------
# Extract today's changelog entries
# ------------------------------------------------------
extract_entries() {
    local date="$1"
    local file="$2"
    local in_section=false
    local content=""

    while IFS= read -r line; do
        # Match date header: ## YYYY-MM-DD or ## [YYYY-MM-DD] or ## YYYY-MM-DD — Description
        if echo "$line" | grep -qE "^## .*${date}"; then
            in_section=true
            continue
        fi

        # Stop at next date header
        if [ "$in_section" = true ] && echo "$line" | grep -qE "^## "; then
            break
        fi

        if [ "$in_section" = true ]; then
            content="${content}${line}
"
        fi
    done < "$file"

    echo "$content"
}

ENTRIES="$(extract_entries "$TARGET_DATE" "$CHANGELOG_FILE")"

if [ -z "$(echo "$ENTRIES" | tr -d '[:space:]')" ]; then
    log "[slack] No changelog entries for $TARGET_DATE — skipping"
    exit 0
fi

# ------------------------------------------------------
# Summarize entries for Slack
# Section headings → bold, table rows → count, bullets → keep
# ------------------------------------------------------
summarize() {
    local raw="$1"
    local summary=""
    local current_section=""
    local table_count=0
    local in_table=false

    # Flush any pending table count
    flush_table() {
        if [ "$in_table" = true ] && [ $table_count -gt 0 ]; then
            summary="${summary}  ${table_count} items
"
            table_count=0
            in_table=false
        fi
    }

    while IFS= read -r line; do
        # Skip empty lines
        if [ -z "$(echo "$line" | tr -d '[:space:]')" ]; then
            continue
        fi

        # Section heading: ### Something
        if echo "$line" | grep -qE "^### "; then
            flush_table
            current_section="${line#### }"
            summary="${summary}*${current_section}*
"
            continue
        fi

        # Table header or separator rows — skip
        if echo "$line" | grep -qE '^\|.*\|$' && echo "$line" | grep -qE '(Plugin|------)'; then
            in_table=true
            continue
        fi

        # Table data row — count it
        if echo "$line" | grep -qE '^\|'; then
            in_table=true
            ((table_count++))
            continue
        fi

        # Bullet points — keep them
        if echo "$line" | grep -qE '^[[:space:]]*[-*] '; then
            flush_table
            summary="${summary}${line}
"
            continue
        fi

        # Anything else — keep as-is
        flush_table
        summary="${summary}${line}
"
    done <<< "$raw"

    # Final flush
    flush_table

    echo "$summary"
}

SUMMARY="$(summarize "$ENTRIES")"

# Truncate to 2800 chars (Slack section limit is 3000)
if [ ${#SUMMARY} -gt 2800 ]; then
    SUMMARY="${SUMMARY:0:2797}..."
fi

# ------------------------------------------------------
# Escape JSON special characters
# Uses jq if available, otherwise sed/awk fallback
# ------------------------------------------------------
json_escape() {
    local text="$1"
    if command -v jq &> /dev/null; then
        echo -n "$text" | jq -Rs '.'
    else
        # Manual escape: backslash, quotes, newlines, tabs
        echo -n "$text" | awk '
        BEGIN { ORS="" }
        {
            gsub(/\\/, "\\\\")
            gsub(/"/, "\\\"")
            gsub(/\t/, "\\t")
            if (NR > 1) printf "\\n"
            print
        }
        END { }
        ' | sed 's/^/"/;s/$/"/'
    fi
}

# ------------------------------------------------------
# Build Slack Block Kit payload
# ------------------------------------------------------
ESCAPED_SUMMARY="$(json_escape "$SUMMARY")"
ESCAPED_SITE="$(json_escape "$SITE_NAME")"

# Build footer text
FOOTER="Claude WPM"
if [ -n "$WPM_VERSION" ]; then
    FOOTER="Claude WPM v${WPM_VERSION}"
fi
FOOTER="${FOOTER} | Blaze Commerce"

PAYLOAD="{
  \"blocks\": [
    {
      \"type\": \"header\",
      \"text\": {
        \"type\": \"plain_text\",
        \"text\": \"\\ud83d\\udccb ${SITE_NAME} \\u2014 ${TARGET_DATE}\",
        \"emoji\": true
      }
    },
    {
      \"type\": \"section\",
      \"text\": {
        \"type\": \"mrkdwn\",
        \"text\": ${ESCAPED_SUMMARY}
      }
    },
    {
      \"type\": \"context\",
      \"elements\": [
        {
          \"type\": \"mrkdwn\",
          \"text\": \"${FOOTER}\"
        }
      ]
    }
  ]
}"

# ------------------------------------------------------
# Post to Slack
# ------------------------------------------------------
log "[slack] Posting changelog for $SITE_NAME ($TARGET_DATE)..."

HTTP_CODE="$(curl -s -o /dev/null -w '%{http_code}' \
    -X POST \
    -H 'Content-Type: application/json' \
    -d "$PAYLOAD" \
    "$WEBHOOK_URL" 2>/dev/null)" || true

if [ "$HTTP_CODE" = "200" ]; then
    log "[slack] Posted successfully"
else
    log "[slack] Warning: Slack returned HTTP $HTTP_CODE (non-fatal)"
fi

# Always exit 0 — never break the parent workflow
exit 0
