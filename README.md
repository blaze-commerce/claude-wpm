# Claude Code WordPress Configuration

Reusable Claude Code configuration for WordPress/WooCommerce projects hosted on Kinsta.

---

## Important: Deployment vs Local Components

This repository contains **two types of components** with different purposes:

| Component | Location | Purpose | Deploy to Live Sites? |
|-----------|----------|---------|----------------------|
| Hooks | `hooks/` | Safety blocks for Claude Code | YES |
| Skills | `skills/` | Specialist prompts | YES |
| Commands | `commands/` | Workflow automation (`/wpm`) | YES |
| Scripts | `scripts/` | Shell maintenance scripts | YES |
| **QA Tests** | `qa/` | Cross-browser E2E testing | **NO - LOCAL ONLY** |
| **Plans** | `plans/` | Architecture & reference docs | **NO - Reference only** |

### The Golden Rule

```
┌─────────────────────────────────────────────────────────────────────┐
│  LIVE SITES (Kinsta):  hooks/ + skills/ + commands/ + scripts/     │
│  LOCAL MACHINE ONLY:   qa/                                          │
│  REFERENCE ONLY:       plans/                                       │
└─────────────────────────────────────────────────────────────────────┘
```

**Why?** The `qa/` folder contains Playwright tests that run on your MacBook. The `plans/` folder contains architecture documentation for reference.

---

## What's Included

```
.claude/
├── CLAUDE-BASE.md          # Reusable instructions (auto-loaded by Claude)
├── README.md               # This file - setup instructions
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
│   ├── blz-wpm.sh          # Direct SSH maintenance script
│   └── create-deploy-zip.sh # Build deployment package
├── settings.json           # Permissions and hook configuration
│
├── plans/                  # Architecture & reference documentation
│   ├── blaze-qa-test-framework.md   # QA test code and structure
│   └── claude-wpm-master-plan.md    # Master plan and prompts
│
└── qa/                     # LOCAL ONLY - Cross-browser E2E tests
    ├── config/             # Playwright configuration
    ├── shared/             # Reusable test fixtures & utilities
    ├── sites/              # Per-site test configurations
    │   ├── birdbusta.net/
    │   └── _template/      # Copy for new sites
    ├── package.json        # Node.js dependencies
    └── README.md           # QA-specific documentation
```

## Deployment Workflows

### A. Deploy to New Live Site (Kinsta) - RECOMMENDED

**Use GitHub Releases** - pre-built zip with `qa/` and `plans/` already excluded.

**Step 0: Install Claude Code** (if not already installed)
```bash
# For production servers (recommended) - stable channel
curl -fsSL https://claude.ai/install.sh | bash -s stable

# Or latest channel (newest features, may have occasional issues)
curl -fsSL https://claude.ai/install.sh | bash
```

> **Note:** npm installation (`npm install -g @anthropic-ai/claude-code`) is **deprecated**. Use the native installer above.

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. Go to: github.com/blaze-commerce/claude-wpm/releases            │
│  2. Download: claude-wpm-deploy.zip                                 │
│  3. Upload to Kinsta → Extract to public/                           │
│  4. Start Claude Code:  claude                                      │
│  5. Run /init  ← Generates site CLAUDE.md                          │
│  6. Run /wpm   ← Optional: populates plugin inventory               │
└─────────────────────────────────────────────────────────────────────┘
```

**Direct download link:**
```
https://github.com/blaze-commerce/claude-wpm/releases/latest/download/claude-wpm-deploy.zip
```

### Updating an Existing Site

When updating a site that already has `.claude/` installed:

```bash
# Download and overwrite existing files
cd /path/to/wordpress
unzip -o claude-wpm-deploy.zip
```

**Unzip options:**
| Flag | Behavior |
|------|----------|
| `-o` | Overwrite all (recommended for updates) |
| `-n` | Never overwrite (keeps existing) |
| `-u` | Only overwrite if zip is newer |

**Safe to overwrite:** The deploy zip excludes `cache/`, `settings.local.json`, and site-specific data.

**Caution:** If you've customized hooks, skills, or commands, use `-n` or back up first.

**What's in the deploy zip:**
```
.claude/
├── CLAUDE-BASE.md     Included
├── README.md          Included
├── hooks/             Included
├── skills/            Included
├── commands/          Included
├── scripts/           Included
├── settings.json      Included
├── CONTRIBUTING.md    EXCLUDED (for repo contributors only)
├── qa/                EXCLUDED (for local testing only)
├── plans/             EXCLUDED (reference docs, stay in repo)
└── cache/             EXCLUDED (temporary files)
```

---

### Creating a New Release (Maintainers)

**Option 1: Automatic (GitHub Actions)**

1. Go to GitHub → Releases → "Create a new release"
2. Create new tag: `v1.0.0` (use semantic versioning)
3. Add release notes
4. Click "Publish release"
5. GitHub Actions automatically builds and attaches `claude-wpm-deploy.zip`

**Option 2: Manual (Local)**

```bash
# On your MacBook
cd claude-wpm
.claude/scripts/create-deploy-zip.sh 1.0.0

# Creates: dist/claude-wpm-deploy-1.0.0.zip
# Then upload to GitHub Release manually
```

---

### B. Setup Local QA Testing (Your MacBook)

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. Clone full repo to MacBook                                      │
│  2. cd claude-wpm/.claude/qa                                        │
│  3. npm install                                                     │
│  4. npx playwright install  (downloads browsers)                    │
│  5. Update sites/<site>/site.config.ts with real URLs               │
│  6. npm test                                                        │
└─────────────────────────────────────────────────────────────────────┘
```

**How QA tests work:**
```
┌──────────────────┐         HTTPS         ┌──────────────────┐
│  Your MacBook    │ ───────────────────▶  │  Live Kinsta     │
│                  │                       │  Site            │
│  - Playwright    │   Tests run like a    │                  │
│  - qa/ folder    │   real browser user   │  birdbusta.net   │
│  - Node.js       │                       │  WooCommerce     │
└──────────────────┘                       └──────────────────┘
```

The tests run **FROM** your local machine, testing the live site via HTTP.
They do NOT run on the server.

---

### C. Quick Reference

| Task | Where | Command |
|------|-------|---------|
| Install Claude Code | Server/Local | `curl -fsSL https://claude.ai/install.sh \| bash -s stable` |
| Deploy to live site | Server | Download from GitHub Releases |
| Run maintenance | Live site | `/wpm` via Claude Code |
| Run E2E tests | Local MacBook | `cd .claude/qa && npm test` |
| Add new test site | Local MacBook | Copy `qa/sites/_template/` |
| View architecture docs | Repo | See `plans/` folder |

---

## Quick Setup (Live Site)

**Step-by-step:**

0. **Install Claude Code** (if not already installed)
   ```bash
   # Stable channel recommended for production
   curl -fsSL https://claude.ai/install.sh | bash -s stable
   ```

1. **Download deploy zip** from GitHub Releases (NOT the "Download ZIP" button)
   - The deploy zip excludes `qa/` and `plans/` folders automatically

2. **Upload to Kinsta** and extract to WordPress root (`public/`)

3. **Start Claude Code** in that directory

4. **Run `/init`** - This generates a site-specific `CLAUDE.md` with:
   - Directory structure
   - Detected plugins/themes
   - Project-specific details

5. **(Optional) Run `/wpm`** - Populates the plugin inventory section

The reusable instructions in `.claude/CLAUDE-BASE.md` are auto-loaded alongside your site-specific `CLAUDE.md`.

## Recommended CLAUDE.md Structure

After running `/init`, ensure your `CLAUDE.md` includes these sections for full compatibility with `/wpm`:

```markdown
# CLAUDE.md

## Site Overview
[Brief description of the site - type, theme, purpose]

## Directory Structure
[Generated by /init]

## Child Theme Customizations
| File | Purpose |
|------|---------|
[Document key custom files]

## Key Plugins
[Categorize important plugins: E-commerce, Payments, Shipping, SEO, etc.]

## Custom Endpoints / APIs
[Document any custom REST endpoints]

## Plugin Inventory

**Last updated:** [DATE] via `/wpm`

This section is auto-updated when running `/wpm`. New plugins are marked with `<- NEW`.

### Active Plugins

| Plugin | Version | Notes |
|--------|---------|-------|

### Inactive Plugins

| Plugin | Version | Notes |
|--------|---------|-------|

### Must-Use Plugins

| Plugin | Version | Notes |
|--------|---------|-------|
```

**Important:** The `## Plugin Inventory` section with the table format is required for `/wpm` to auto-update plugin lists.

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
- `/senior-architect` - Architectural decisions, trade-off analysis, planning

### Commands
- `/wpm` - WordPress Maintenance (updates core, plugins, themes in correct order)

### QA Testing (Local Only)

Cross-browser WooCommerce testing using Playwright. **Runs on your MacBook, not on servers.**

**Browsers supported:** Chrome, Firefox, Safari, Edge + Mobile viewports

**Test modules:**
| Module | Coverage |
|--------|----------|
| `shop-page.spec.ts` | Add to cart from shop/category pages |
| `single-product.spec.ts` | Product page, variations, quantity |
| `cart.spec.ts` | Cart updates, coupons, removal |
| `checkout.spec.ts` | Billing, shipping, payment flow |

**Commands (run from `qa/` directory):**
```bash
npm test                 # All tests, all browsers
npm run test:chrome      # Chrome only
npm run test:safari      # Safari only
npm run test:headed      # Watch tests run visually
npm run test:ui          # Interactive test UI
```

**Adding a new site:**
1. Copy `qa/sites/_template/` to `qa/sites/newsite.com/`
2. Edit `site.config.ts` with correct URLs
3. Update `test-data.ts` with test products
4. Run: `npm test -- --grep @newsite`

See `plans/blaze-qa-test-framework.md` for complete test code and implementation details.

---

### Reference Documentation

The `plans/` folder contains architecture and reference documentation:

| Document | Purpose |
|----------|---------|
| `claude-wpm-master-plan.md` | Master plan with prompts, checklists, and architecture decisions |
| `blaze-qa-test-framework.md` | Complete Playwright test code ready to implement |

These documents are committed to git for reference but excluded from deployment packages.

---

## Configuration Sources

| Component | Source |
|-----------|--------|
| Hooks | [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) |
| Skills | [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) |

## Auto-Update Check

Claude is instructed (in CLAUDE-BASE.md) to check the source repositories at the start of each session for new hooks/skills.

## Repository Structure Summary

```
claude-wpm/                    # Git repository root
├── .claude/                   # This folder
│   ├── hooks/                 # Deploy to live sites
│   ├── skills/                # Deploy to live sites
│   ├── commands/              # Deploy to live sites
│   ├── scripts/               # Deploy to live sites
│   ├── plans/                 # Reference docs (in git, not deployed)
│   │   ├── blaze-qa-test-framework.md
│   │   └── claude-wpm-master-plan.md
│   ├── qa/                    # LOCAL ONLY - never deploy
│   │   ├── sites/
│   │   │   ├── birdbusta.net/
│   │   │   └── _template/
│   │   └── shared/
│   └── cache/                 # EXCLUDED & gitignored
├── .github/workflows/         # GitHub Actions
└── README.md
```

**Legend:**
- Deploy = Included in deploy zip (for live sites)
- Reference = In git repo, excluded from deploy zip (reference only)
- Local = Local MacBook only (excluded from deploy)
- Excluded = Excluded from deploy zip & gitignored
- Automation = GitHub Actions (excluded from deploy zip)

---

## Contributing

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for:
- Branch naming conventions (`feature/`, `fix/`, `docs/`, etc.)
- Commit message format (Conventional Commits)
- Semantic versioning for releases
- Pull request guidelines

**Quick Reference:**
```bash
# Branch naming
git checkout -b feature/add-new-skill
git checkout -b fix/hook-regex-error

# Commit format
git commit -m "feat(scope): description"
git commit -m "fix(hooks): correct wp-config regex"
```

---

## License

MIT - Feel free to customize for your needs.

---

**Maintained by Blaze Commerce**

| Component | Repository |
|-----------|------------|
| This config | `git@github.com:blaze-commerce/claude-wpm.git` |
| Premium plugins | `git@github.com:blaze-commerce/wp-premium-plugins.git` |
