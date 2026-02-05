# WordPress Playground

Expert guidance for WordPress Playground - instant local WordPress environments.

## When to Use

Use when you need to:
- Quickly test plugins or themes
- Run Blueprint workflows for automated setup
- Build reproducible site snapshots
- Debug with isolated environments
- Share bug reports with demo sites

## Prerequisites

- Node.js >= 20.18
- npm/npx available

## Quick Start

### Launch from Plugin/Theme Directory

```bash
cd my-plugin/
npx @wp-playground/cli@latest server --auto-mount
```

Opens at `http://localhost:9400` with automatic plugin/theme detection.

### Launch Fresh Instance

```bash
npx @wp-playground/cli@latest server
```

## Blueprints

Blueprints are JSON files that define WordPress setup:

```json
{
    "landingPage": "/wp-admin/",
    "preferredVersions": {
        "php": "8.0",
        "wp": "latest"
    },
    "steps": [
        {
            "step": "installPlugin",
            "pluginData": {
                "resource": "wordpress.org/plugins",
                "slug": "akismet"
            }
        },
        {
            "step": "installTheme",
            "themeData": {
                "resource": "wordpress.org/themes",
                "slug": "twentytwentyfour"
            }
        }
    ]
}
```

### Run Blueprint

```bash
# Local file
npx @wp-playground/cli@latest run-blueprint blueprint.json

# Remote URL
npx @wp-playground/cli@latest run-blueprint https://example.com/blueprint.json
```

## Debugging with Xdebug

```bash
npx @wp-playground/cli@latest server --xdebug
```

Connect your IDE's Xdebug client to step through code.

## Snapshots

Build a snapshot for sharing:

```bash
# Export as ZIP
npx @wp-playground/cli@latest snapshot --output=my-site.zip
```

Useful for bug reports or distribution.

## Important Limitations

- **Ephemeral**: Instances are temporary and SQLite-backed
- **Never point at production data**
- Mounted files are copied into in-memory filesystem
- Some PHP extensions not available
- Native database access not supported

## When to Use Alternatives

Consider Docker/Local/MAMP if you need:
- PHP extensions
- Native MySQL database
- Persistent environments
- System-level integrations

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+ (emulated)
- Node.js >= 20.18

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-playground)
