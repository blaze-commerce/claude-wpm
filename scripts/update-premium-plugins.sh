#!/bin/bash

# ------------------------------------------------------
# update-premium-plugins.sh
# Pull premium plugins from private Git repository
# From Blaze Commerce
# ------------------------------------------------------

set -e

# Configuration
REPO_URL="${PREMIUM_PLUGINS_REPO:-git@github.com:blaze-commerce/wp-premium-plugins.git}"
REPO_BRANCH="${PREMIUM_PLUGINS_BRANCH:-main}"

# Auto-detect paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WP_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLUGINS_DIR="$WP_ROOT/wp-content/plugins"
CACHE_DIR="$WP_ROOT/.claude/cache/premium-plugins"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# Check requirements
check_requirements() {
    local missing=0

    if ! command -v git &> /dev/null; then
        log_error "git is not installed"
        missing=1
    fi

    if ! command -v unzip &> /dev/null; then
        log_error "unzip is not installed"
        missing=1
    fi

    if ! command -v wp &> /dev/null; then
        log_warn "WP-CLI not found - plugin activation/deactivation will be skipped"
    fi

    if [ $missing -eq 1 ]; then
        exit 1
    fi
}

# Clone or update the repository
sync_repo() {
    log_step "Syncing premium plugins repository..."

    mkdir -p "$(dirname "$CACHE_DIR")"

    if [ -d "$CACHE_DIR/.git" ]; then
        log_info "Updating existing repository..."
        cd "$CACHE_DIR"
        git fetch origin
        git reset --hard "origin/$REPO_BRANCH"
        cd "$WP_ROOT"
    else
        log_info "Cloning repository..."
        rm -rf "$CACHE_DIR"
        git clone --branch "$REPO_BRANCH" --depth 1 "$REPO_URL" "$CACHE_DIR"
    fi

    log_info "Repository synced successfully"
}

# List available plugins in repo
list_plugins() {
    log_step "Available premium plugins:"
    echo ""

    if [ ! -d "$CACHE_DIR/plugins" ]; then
        log_error "No plugins directory found in repository"
        log_info "Run 'sync' first or check repository structure"
        return 1
    fi

    printf "  %-35s %-15s %-15s %s\n" "PLUGIN" "REPO VERSION" "INSTALLED" "STATUS"
    printf "  %-35s %-15s %-15s %s\n" "------" "------------" "---------" "------"

    for plugin_dir in "$CACHE_DIR/plugins"/*; do
        if [ -d "$plugin_dir" ]; then
            plugin_name=$(basename "$plugin_dir")

            # Skip if it's just a README
            if [ "$plugin_name" = "README.md" ]; then
                continue
            fi

            # Get repo version from latest zip
            latest_zip=$(ls -t "$plugin_dir"/*.zip 2>/dev/null | head -1)
            if [ -n "$latest_zip" ]; then
                repo_version=$(basename "$latest_zip" .zip | sed "s/${plugin_name}-//")
            else
                repo_version="-"
            fi

            # Check if installed locally
            if [ -d "$PLUGINS_DIR/$plugin_name" ]; then
                if command -v wp &> /dev/null; then
                    local_version=$(wp plugin get "$plugin_name" --field=version 2>/dev/null || echo "?")
                else
                    local_version="installed"
                fi

                # Compare versions
                if [ "$repo_version" = "$local_version" ]; then
                    status="✓ current"
                elif [ "$repo_version" = "-" ]; then
                    status="no zip in repo"
                else
                    status="⬆ update available"
                fi
            else
                local_version="-"
                status="not installed"
            fi

            printf "  %-35s %-15s %-15s %s\n" "$plugin_name" "$repo_version" "$local_version" "$status"
        fi
    done
    echo ""
}

# Update a single plugin
update_plugin() {
    local plugin_name="$1"
    local plugin_repo_dir="$CACHE_DIR/plugins/$plugin_name"

    if [ ! -d "$plugin_repo_dir" ]; then
        log_error "Plugin '$plugin_name' not found in repository"
        return 1
    fi

    # Find the latest zip file
    local latest_zip=$(ls -t "$plugin_repo_dir"/*.zip 2>/dev/null | head -1)

    if [ -z "$latest_zip" ]; then
        log_error "No zip file found for '$plugin_name'"
        return 1
    fi

    local zip_version=$(basename "$latest_zip" .zip | sed "s/${plugin_name}-//")
    log_step "Updating $plugin_name to version $zip_version..."

    # Check if plugin is active
    local was_active=false
    if command -v wp &> /dev/null; then
        if wp plugin is-active "$plugin_name" 2>/dev/null; then
            was_active=true
            log_info "Deactivating $plugin_name..."
            wp plugin deactivate "$plugin_name" --quiet
        fi
    fi

    # Remove existing plugin
    if [ -d "$PLUGINS_DIR/$plugin_name" ]; then
        log_info "Removing old version..."
        rm -rf "$PLUGINS_DIR/$plugin_name"
    fi

    # Extract new version
    log_info "Extracting $(basename "$latest_zip")..."
    unzip -q "$latest_zip" -d "$PLUGINS_DIR"

    # Verify extraction
    if [ ! -d "$PLUGINS_DIR/$plugin_name" ]; then
        log_error "Extraction failed - plugin directory not created"
        log_warn "The zip might extract to a different folder name"
        return 1
    fi

    # Reactivate if it was active
    if [ "$was_active" = true ] && command -v wp &> /dev/null; then
        log_info "Reactivating $plugin_name..."
        wp plugin activate "$plugin_name" --quiet
    fi

    log_info "✓ $plugin_name updated to $zip_version"
    return 0
}

# Update all premium plugins that are installed
update_all() {
    log_step "Updating all installed premium plugins..."
    echo ""

    if [ ! -d "$CACHE_DIR/plugins" ]; then
        log_error "No plugins directory in repository. Run 'sync' first."
        exit 1
    fi

    local updated=0
    local skipped=0
    local failed=0

    for plugin_dir in "$CACHE_DIR/plugins"/*; do
        if [ -d "$plugin_dir" ]; then
            plugin_name=$(basename "$plugin_dir")

            # Skip README
            if [ "$plugin_name" = "README.md" ]; then
                continue
            fi

            # Only update if already installed
            if [ -d "$PLUGINS_DIR/$plugin_name" ]; then
                # Check if there's a zip to install
                latest_zip=$(ls -t "$plugin_dir"/*.zip 2>/dev/null | head -1)
                if [ -z "$latest_zip" ]; then
                    log_warn "Skipping $plugin_name - no zip in repo"
                    ((skipped++))
                    continue
                fi

                if update_plugin "$plugin_name"; then
                    ((updated++))
                else
                    ((failed++))
                fi
                echo ""
            fi
        fi
    done

    echo "----------------------------------------"
    log_info "Summary: $updated updated, $skipped skipped, $failed failed"
}

# Show usage
usage() {
    echo "Premium Plugin Updater - Blaze Commerce"
    echo ""
    echo "Usage: $0 <command> [plugin-name]"
    echo ""
    echo "Commands:"
    echo "  sync        Pull latest from Git repository"
    echo "  list        List available plugins and versions"
    echo "  update      Update a specific plugin"
    echo "  update-all  Update all installed premium plugins"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 sync                    # Pull latest from repo"
    echo "  $0 list                    # Show available plugins"
    echo "  $0 update elementor-pro    # Update specific plugin"
    echo "  $0 update-all              # Update all premium plugins"
    echo ""
    echo "Repository: $REPO_URL"
}

# Main
main() {
    check_requirements

    case "${1:-help}" in
        sync)
            sync_repo
            ;;
        list)
            sync_repo
            list_plugins
            ;;
        update)
            if [ -z "$2" ]; then
                log_error "Please specify a plugin name"
                echo ""
                usage
                exit 1
            fi
            sync_repo
            update_plugin "$2"
            ;;
        update-all)
            sync_repo
            update_all
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

main "$@"
