# Claude Code WordPress Configuration

Reusable Claude Code configuration for WordPress/WooCommerce projects hosted on Kinsta.

## What's Included

```
.claude/
├── CLAUDE-BASE.md          # Reusable instructions (auto-loaded by Claude)
├── CLAUDE.md.template      # Site-specific template (copy to project root)
├── hooks/
│   └── PreToolUse/
│       ├── block-dangerous-commands.sh
│       └── block-protected-files.sh
├── skills/
│   ├── wordpress-master.md
│   ├── php-pro.md
│   ├── security-auditor.md
│   └── database-administrator.md
├── commands/
│   └── wpm.md              # /wpm - WordPress maintenance command
├── scripts/
│   └── blz-wpm.sh          # Direct SSH maintenance script
└── settings.json           # Permissions and hook configuration
```

## Quick Setup

### New Site Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. Copy .claude/ folder to WordPress root (public/)    │
│  2. Start Claude Code                                   │
│  3. Run /init  ← IMPORTANT! Generates site CLAUDE.md   │
│  4. Run /wpm   ← Optional: populates plugin inventory   │
└─────────────────────────────────────────────────────────┘
```

**Step-by-step:**

1. **Upload `.claude/` folder** to your WordPress project root (usually `public/`)

2. **Start Claude Code** in that directory

3. **Run `/init`** - This generates a site-specific `CLAUDE.md` with:
   - Directory structure
   - Detected plugins/themes
   - Project-specific details

4. **(Optional) Run `/wpm`** - Populates the plugin inventory section

The reusable instructions in `.claude/CLAUDE-BASE.md` are auto-loaded alongside your site-specific `CLAUDE.md`.

## Features

### Safety Hooks
PreToolUse hooks that block dangerous operations:
- Destructive commands (`rm -rf`, `DROP DATABASE`, etc.)
- `wp kinsta cache purge` (causes performance issues on Kinsta)
- Modifications to WordPress core, wp-config.php, parent themes

### Skills (Specialists)
Invoke with `/skill-name`:
- `/wordpress-master` - WordPress/WooCommerce expertise
- `/php-pro` - PHP development
- `/security-auditor` - Security review
- `/database-administrator` - MySQL optimization

### Commands
- `/wpm` - WordPress Maintenance (updates core, plugins, themes in correct order)

## Configuration Sources

| Component | Source |
|-----------|--------|
| Hooks | [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) |
| Skills | [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) |

## Auto-Update Check

Claude is instructed (in CLAUDE-BASE.md) to check the source repositories at the start of each session for new hooks/skills.

## License

MIT - Feel free to customize for your needs.

---

Maintained by Blaze Commerce
