---
title: WordPress Agent Skills
description: Official WordPress AI agent skills from the WordPress organization.
---

Claude WPM integrates with the official [WordPress Agent Skills](https://github.com/WordPress/agent-skills) repository, providing specialized AI assistance for WordPress development.

## Available Skills

### Router & Triage

| Skill | Description |
|-------|-------------|
| [wordpress-router](https://github.com/WordPress/agent-skills/tree/trunk/skills/wordpress-router) | Classifies WordPress repos and routes to the right workflow |
| [wp-project-triage](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-project-triage) | Detects project type, tooling, and versions automatically |

### Block Development

| Skill | Description |
|-------|-------------|
| [wp-block-development](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-block-development) | Gutenberg blocks: `block.json`, attributes, rendering, deprecations |
| [wp-block-themes](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-block-themes) | Block themes: `theme.json`, templates, patterns, style variations |
| [wp-interactivity-api](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-interactivity-api) | Frontend interactivity using `data-wp-*` directives and stores |

### Plugin & API Development

| Skill | Description |
|-------|-------------|
| [wp-plugin-development](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-plugin-development) | Plugin architecture, hooks, settings API, security |
| [wp-rest-api](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-rest-api) | REST API routes/endpoints, schema, auth, response shaping |
| [wp-abilities-api](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-abilities-api) | Capability-based permissions and REST API authentication |

### Operations & Performance

| Skill | Description |
|-------|-------------|
| [wp-wpcli-and-ops](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-wpcli-and-ops) | WP-CLI commands, automation, multisite, search-replace |
| [wp-performance](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-performance) | Profiling, caching, database optimization, Server-Timing |

### Quality & Tools

| Skill | Description |
|-------|-------------|
| [wp-phpstan](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-phpstan) | PHPStan static analysis for WordPress (config, baselines, WP-specific typing) |
| [wp-playground](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-playground) | WordPress Playground for instant local environments |
| [wpds](https://github.com/WordPress/agent-skills/tree/trunk/skills/wpds) | WordPress Design System |

## Installation

These skills are designed to work with AI coding assistants like Claude Code. Each skill bundles:

- **Instructions** - Detailed prompts for the AI assistant
- **Reference documentation** - WordPress-specific knowledge
- **Helper scripts** - Automation tools

### Using with Claude Code

1. Clone the agent-skills repository:
   ```bash
   git clone https://github.com/WordPress/agent-skills.git
   ```

2. Reference skills in your Claude configuration or invoke them directly.

## Resources

- [WordPress Agent Skills Repository](https://github.com/WordPress/agent-skills)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [Gutenberg Handbook](https://developer.wordpress.org/block-editor/)
- [WP-CLI Documentation](https://developer.wordpress.org/cli/commands/)
