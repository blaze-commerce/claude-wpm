# WordPress Project Triage

Deterministic inspection skill for WordPress repositories.

## When to Use

Use when you need to:
- Understand repository structure before modifications
- Classify project type (plugin, theme, block theme, etc.)
- Detect available tooling and test infrastructure
- Identify version indicators

## Output Schema

The detection outputs JSON with three key fields:

```json
{
    "project": {
        "kind": "plugin|theme|block-theme|mu-plugin|core|unknown"
    },
    "signals": {
        "hasBlockJson": true,
        "hasThemeJson": true,
        "hasPluginHeader": false
    },
    "tooling": {
        "npm": true,
        "composer": true,
        "phpunit": true,
        "phpstan": false
    }
}
```

## Project Classification

| Kind | Key Signals |
|------|-------------|
| `plugin` | Plugin header file, hooks directory |
| `theme` | style.css with theme header |
| `block-theme` | theme.json, templates/, parts/ |
| `mu-plugin` | Located in mu-plugins directory |
| `core` | wp-includes/, wp-admin/ |
| `unknown` | Cannot determine type |

## Usage

Run detection at repository root:

```bash
node detect_wp_project.mjs
```

## Interpreting Results

### Project Kind
Determines which workflow/skill to route to:
- `plugin` → wp-plugin-development
- `theme` → Theme development
- `block-theme` → wp-block-themes
- Blocks detected → wp-block-development

### Signals
Indicates what features are present:
- `hasBlockJson` - Contains Gutenberg blocks
- `hasThemeJson` - Uses block theme styling
- `hasPluginHeader` - Valid plugin file

### Tooling
Shows available development tools:
- `npm` - Node.js package management
- `composer` - PHP package management
- `phpunit` - PHP unit testing
- `phpstan` - Static analysis

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `unknown` classification | Wrong repo path | Verify directory |
| Missing signals | Detection incomplete | Update detector script |
| Slow detection | Large repo | Expand ignore directories |

## After Changes

Re-run detection after structural changes like:
- Adding theme.json
- Adding build configuration
- Changing directory structure

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+
- Node.js for detection script

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-project-triage)
