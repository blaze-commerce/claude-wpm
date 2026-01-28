# Claude WPM (WordPress Maintenance)

Claude Code configuration for WordPress/WooCommerce projects. This repository contains three distinct services:

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLAUDE WPM SERVICES                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  [WPM]      WordPress Maintenance   → Deployed to Kinsta sites      │
│             hooks, skills, commands, scripts                        │
│                                                                     │
│  [WPM-QA]   Quality Assurance       → GitHub Pages & local testing  │
│             docs/, qa/, Playwright tests                            │
│                                                                     │
│  [REPO]     Repository              → Stays in GitHub only          │
│             CI/CD, workflows, contributing docs                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Service Overview

| Service | Label | Purpose | Destination |
|---------|-------|---------|-------------|
| **WPM** | `[WPM]` | WordPress maintenance tools for Claude Code | Kinsta/WordPress sites |
| **QA** | `[WPM-QA]` | Documentation & testing | GitHub Pages + local MacBook |
| **Repo** | `[REPO]` | Development & CI/CD | GitHub repository only |

### What Goes Where

| Component | Label | Description |
|-----------|-------|-------------|
| `hooks/` | `[WPM]` | Safety blocks for dangerous commands |
| `skills/` | `[WPM]` | Specialist prompts (WordPress, PHP, Security, DB) |
| `commands/` | `[WPM]` | Workflow automation (`/wpm`) |
| `scripts/` | `[WPM]` | Maintenance scripts (audit, update, etc.) |
| `docs/` | `[WPM-QA]` | GitHub Pages documentation site |
| `qa/` | `[WPM-QA]` | Playwright E2E tests (local MacBook) |
| `plans/` | `[REPO]` | Architecture & reference docs |
| `.github/` | `[REPO]` | CI/CD workflows |

> **📋 See [FILE_MAPPING.md](FILE_MAPPING.md)** for the complete file inventory with labels.

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
│   ├── audit-wpm.sh        # Compare local vs repo files
│   ├── blz-wpm.sh          # Direct SSH maintenance script
│   ├── check-version.sh    # Check for updates
│   ├── create-deploy-zip.sh # Build deployment package [REPO]
│   ├── update-claude-wpm.sh # Auto-update from GitHub releases
│   └── verify-deploy-zip.sh # QA check before release [REPO]
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

### A. Deploy to New Live Site (Kinsta)

```
┌────────────────────────────────────────────────────────────────────┐
│                    NEW SITE DEPLOYMENT FLOW                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. INSTALL       2. DOWNLOAD       3. UPLOAD         4. RUN       │
│  ──────────       ───────────       ────────          ──────       │
│                                                                    │
│  ┌──────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐   │
│  │  Claude  │    │ claude-   │    │  Kinsta   │    │  claude   │   │
│  │  Code    │───▶│ wpm-      │───▶│  public/  │───▶│  /init    │   │
│  │  CLI     │    │ deploy.zip│    │  .claude/ │    │  /wpm     │   │
│  └──────────┘    └───────────┘    └───────────┘    └───────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

| Step | Action | Command/Link |
|------|--------|--------------|
| 1 | Install Claude Code (if not installed) | `curl -fsSL https://claude.ai/install.sh \| bash -s stable` |
| 2 | Download deploy zip | [claude-wpm-deploy.zip](https://github.com/blaze-commerce/claude-wpm/releases/latest/download/claude-wpm-deploy.zip) |
| 3 | Upload & extract to `public/` | Via SSH or SFTP |
| 4 | Run Claude & initialize | `claude` → `/init` → `/wpm` |

> **Note:** Running `/init` again is safe - it regenerates the site's `CLAUDE.md` if you need to refresh it.

### B. Updating an Existing Site

```
┌─────────────────────────────────────────────────────────────────────┐
│                    EXISTING SITE UPDATE FLOW                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Step 1: AUDIT              Step 2: CHECK           Step 3: UPDATE │
│   ─────────────              ────────────            ────────────── │
│                                                                     │
│   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐   │
│   │ audit-wpm   │         │check-version│         │update-claude│   │
│   │    .sh      │ ──────▶ │    .sh      │ ──────▶ │  -wpm.sh    │   │
│   └─────────────┘         └─────────────┘         └─────────────┘   │
│         │                       │                       │           │
│         ▼                       ▼                       ▼           │
│   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐   │
│   │ Compare:    │         │ Local: v1.0 │         │ Downloads   │   │
│   │ Local vs    │         │ Latest: v1.2│         │ latest zip  │   │
│   │ Repo files  │         │             │         │ & updates   │   │
│   └─────────────┘         └─────────────┘         └─────────────┘   │
│         │                       │                       │           │
│         ▼                       ▼                       ▼           │
│   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐   │
│   │ ✓ Present   │         │ "Update     │         │ ✓ Updated   │   │
│   │ ✗ Missing   │         │  available!"│         │   to v1.2   │   │
│   │ + Extra     │         │             │         │             │   │  
│   └─────────────┘         └─────────────┘         └─────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Commands:**
```bash
bash .claude/scripts/audit-wpm.sh      # 1. See what's different
bash .claude/scripts/check-version.sh  # 2. Check version
bash .claude/scripts/update-claude-wpm.sh  # 3. Update
```

**Example audit output:**
```
[WPM] Files - Should be on Kinsta
  ✓ CLAUDE-BASE.md
  ✓ settings.json
  ✗ MISSING: scripts/audit-wpm.sh    ← New file in repo

Extra Local Files
  ? README.md (repo-only, can remove)
  + custom-skill.md (your custom file)
```

> **Tip:** Claude reminds developers to check for updates at session start (configured in `CLAUDE-BASE.md`).

**Alternative: Manual Update**

```bash
cd /path/to/wordpress
unzip -o claude-wpm-deploy.zip   # -o = overwrite all
```

---

### C. Creating a New Release (Maintainers)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    RELEASE CREATION FLOW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Option A: Automatic (GitHub Actions)                              │
│   ────────────────────────────────────                              │
│                                                                     │
│   Create Tag ──▶ Push ──▶ GitHub Actions ──▶ Release + Zip          │
│   (v1.2.0)                 ┌────────────┐                           │
│                            │ 1. Build   │                           │
│                            │ 2. Verify  │ ← FILE_MAPPING.md         │
│                            │ 3. Package │                           │
│                            │ 4. Release │                           │
│                            └────────────┘                           │
│                                                                     │
│   Option B: Manual (Local)                                          │
│   ────────────────────────                                          │
│                                                                     │
│   Run Script ──▶ Verify ──▶ Upload to GitHub                        │
│   ┌─────────────────────────────────┐                               │
│   │ .claude/scripts/create-deploy-  │                               │
│   │ zip.sh 1.2.0                    │                               │
│   └─────────────────────────────────┘                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Option A: Automatic (Recommended)**
1. Create new tag: `git tag v1.2.0`
2. Push: `git push origin v1.2.0`
3. GitHub Actions builds, verifies, and publishes

**Option B: Manual**
```bash
.claude/scripts/create-deploy-zip.sh 1.2.0
# Creates: dist/claude-wpm-deploy-1.2.0.zip
# Upload to GitHub Releases manually
```

**What's in the deploy zip (`[WPM]` files only):**
```
.claude/
├── CLAUDE-BASE.md        [WPM] ✓
├── settings.json         [WPM] ✓
├── commands/             [WPM] ✓
├── hooks/                [WPM] ✓
├── skills/               [WPM] ✓
├── scripts/              [WPM] ✓ (except create-deploy-zip, verify-deploy-zip)
│
├── README.md             [REPO] ✗ excluded
├── plans/                [REPO] ✗ excluded
├── qa/                   [WPM-QA] ✗ excluded
├── docs/                 [WPM-QA] ✗ excluded
└── .github/              [REPO] ✗ excluded
```

---

## Local Development [WPM-QA]

### Setup QA Testing (Your MacBook)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LOCAL QA TESTING FLOW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Your MacBook                              Live Kinsta Site        │
│   ────────────                              ────────────────        │
│                                                                     │
│   ┌───────────────┐        HTTPS           ┌───────────────┐       │
│   │  Playwright   │ ─────────────────────▶ │  WordPress    │       │
│   │  + Node.js    │    Tests run like a    │  WooCommerce  │       │
│   │  qa/ folder   │    real browser user   │               │       │
│   └───────────────┘                        └───────────────┘       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Setup steps:**
```bash
git clone git@github.com:blaze-commerce/claude-wpm.git
cd claude-wpm/qa
npm install
npx playwright install    # Downloads browsers
```

**Run tests:**
```bash
npm test                  # All tests, all browsers
npm run test:chrome       # Chrome only
npm run test:headed       # Watch tests visually
```

> Tests run FROM your MacBook, testing live sites via HTTPS. They do NOT run on the server.

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

---

### Reference Documentation

| Document | Location | Purpose |
|----------|----------|---------|
| `FILE_MAPPING.md` | Repo root | Complete file inventory (auto-updated) |
| `plans/claude-wpm-master-plan.md` | `[REPO]` | Master plan and architecture |
| `plans/blaze-qa-test-framework.md` | `[REPO]` | Playwright test implementation |

---

## Configuration Sources

| Component | Source |
|-----------|--------|
| Hooks | [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) |
| Skills | [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) |

> Claude checks these repositories for updates at session start (configured in `CLAUDE-BASE.md`).

---

## File Mapping & Release Verification Workflow

When you add, remove, or modify files, here's what happens automatically:

```
┌─────────────────────────────────────────────────────────────────────────┐
│  1. You add/remove files → Push to main                                 │
│                    ↓                                                    │
│  2. GitHub Actions runs update-mapping.yml                              │
│     • Uses `find` command to discover all files                         │
│     • Labels each: [WPM], [WPM-QA], or [REPO]                           │
│     • Updates FILE_MAPPING.md automatically                             │
│                    ↓                                                    │
│  3. On release (tag push), release.yml runs                             │
│     • Creates deploy zip                                                │
│     • verify-deploy-zip.sh reads [WPM] files from FILE_MAPPING.md       │
│     • Verifies zip contains all required files                          │
│     • Blocks release if verification fails                              │
└─────────────────────────────────────────────────────────────────────────┘
```

**Key points:**
- `FILE_MAPPING.md` is the **single source of truth**
- No hardcoded file lists to maintain manually
- Adding a new skill/hook automatically updates the verification checklist
- Release blocked if required files are missing from deploy zip

**Example:** Adding a new skill
1. Create `skills/my-new-skill.md`
2. Push to main
3. FILE_MAPPING.md auto-updates with `- skills/my-new-skill.md [WPM]`
4. Next release: verification will check for this file in the zip

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
