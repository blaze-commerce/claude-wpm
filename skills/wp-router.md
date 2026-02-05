# WordPress Router

Classification and delegation skill for WordPress codebases.

## When to Use

Use when you need to:
- Classify a WordPress repository (plugin, theme, block theme, Gutenberg blocks, WP core)
- Route to the correct workflow/skill based on project type
- Determine appropriate handling approaches and guardrails

## Core Procedure

1. **Detect Project Type**: Run project detection to identify codebase type
2. **Analyze Output**: Determine if it's a plugin, theme, block-based theme, or core installation
3. **Route to Specialist**: Direct work to relevant domain skill based on user goals

## Decision Framework

| Project Type | Characteristics | Route To |
|--------------|-----------------|----------|
| Plugin | Has plugin header file, hooks | wp-plugin-development |
| Classic Theme | style.css, functions.php | Theme development |
| Block Theme | theme.json, templates/, parts/ | wp-block-themes |
| Gutenberg Block | block.json, src/ | wp-block-development |
| WP Core | wp-includes/, wp-admin/ | Core contribution |

## Verification

After making changes, re-run detection to confirm file structure integrity.

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wordpress-router)
