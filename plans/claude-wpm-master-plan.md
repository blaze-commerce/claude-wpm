# Claude-WPM Master Plan

> **Purpose:** Complete documentation of the claude-wpm repository structure, deployment workflow, and QA testing framework. Reference this document to avoid repeating discussions.

---

## Table of Contents

1. [Repository Overview](#1-repository-overview)
2. [Current State vs Planned State](#2-current-state-vs-planned-state)
3. [Deployment Workflow](#3-deployment-workflow)
4. [QA Testing Framework](#4-qa-testing-framework)
5. [GitHub Pages for Test Reports](#5-github-pages-for-test-reports)
6. [Git Conventions](#6-git-conventions)
7. [Prompts for Local Claude Code](#7-prompts-for-local-claude-code)
8. [Checklist](#8-checklist)

---

## 1. Repository Overview

**Repo:** `git@github.com:blaze-commerce/claude-wpm.git`

### Purpose
Reusable Claude Code configuration for WordPress/WooCommerce sites hosted on Kinsta.

### Two Separate Systems

This repository contains **two completely separate systems** that should never be mixed:

```
┌─────────────────────────────────────────────────────────────────────┐
│  SYSTEM 1: WPM (WordPress Manager)                                  │
│  ─────────────────────────────────────────────────────────────────  │
│  Purpose:   Claude Code configuration for Kinsta live sites         │
│  Contains:  hooks/ + skills/ + commands/ + scripts/                 │
│  Deployed:  Via GitHub Releases → claude-wpm-deploy.zip             │
│  Used on:   Remote Kinsta servers                                   │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│  SYSTEM 2: QA (Quality Assurance)                                   │
│  ─────────────────────────────────────────────────────────────────  │
│  Purpose:   E2E browser testing for WooCommerce sites               │
│  Contains:  qa/ folder with Playwright tests                        │
│  Runs on:   LOCAL MacBook only (never deployed to servers)          │
│  Reports:   Published to GitHub Pages after tests pass              │
└─────────────────────────────────────────────────────────────────────┘
```

**Critical Rule:** The `qa/` folder is **NEVER** included in the WPM deploy zip. QA tests run locally and test live sites via HTTPS like a real browser user.

### Target Structure

```
claude-wpm/
├── .claude/
│   ├── hooks/PreToolUse/           # Safety hooks → Deploy to live sites
│   │   ├── block-dangerous-commands.sh
│   │   └── block-protected-files.sh
│   ├── skills/                     # Specialists → Deploy to live sites
│   │   ├── wordpress-master.md
│   │   ├── php-pro.md
│   │   ├── security-auditor.md
│   │   ├── database-administrator.md
│   │   └── senior-architect.md
│   ├── commands/                   # Commands → Deploy to live sites
│   │   └── wpm.md
│   ├── scripts/                    # Scripts → Deploy to live sites
│   │   ├── blz-wpm.sh
│   │   └── create-deploy-zip.sh
│   ├── plans/                      # Reference docs → In git, not deployed
│   │   ├── blaze-qa-test-framework.md
│   │   └── claude-wpm-master-plan.md
│   ├── qa/                         # LOCAL ONLY → Never deploy
│   │   ├── config/
│   │   ├── shared/
│   │   ├── sites/
│   │   │   ├── birdbusta.net/
│   │   │   └── _template/
│   │   ├── package.json
│   │   └── README.md
│   ├── CLAUDE-BASE.md
│   ├── CONTRIBUTING.md             # Git conventions & standards
│   ├── README.md                   # Main documentation
│   ├── settings.json
│   └── .gitignore
├── .github/
│   └── workflows/
│       ├── release.yml             # Auto-build deploy zip
│       └── test-report.yml         # Publish test reports to GitHub Pages
└── README.md
```

**Legend:**
- Deploy to live sites = Included in deploy zip (for Kinsta live sites)
- Reference docs = In git repo, excluded from deploy zip
- LOCAL ONLY = Local MacBook only (excluded from deploy)

---

## 2. Current State vs Planned State

### WPM System (Kinsta Deployment)

| Component | Status | Notes |
|-----------|--------|-------|
| hooks/ | ✅ Done | Safety hooks for Claude Code |
| skills/ | ✅ Done | Specialist prompts |
| commands/ | ✅ Done | /wpm command |
| scripts/ | ✅ Done | blz-wpm.sh, create-deploy-zip.sh |
| .github/workflows/release.yml | ✅ Done | Auto-builds deploy zip |
| plans/ | ✅ Done | Reference docs (excluded from zip) |

### QA System (Local Testing)

| Component | Status | Notes |
|-----------|--------|-------|
| qa/config/ | ⏳ Planned | Playwright config |
| qa/shared/ | ⏳ Planned | Reusable selectors, fixtures |
| qa/sites/birdbusta.net/ | ⏳ Planned | First test site |
| qa/sites/_template/ | ⏳ Planned | Template for new sites |
| qa/scripts/publish-report.sh | ⏳ Planned | Publish to GitHub Pages |
| docs/qa-report/ | ⏳ Planned | GitHub Pages source |
| .github/workflows/deploy-report.yml | ⏳ Planned | Deploy reports to Pages |

---

## 3. Deployment Workflow

### For New Kinsta Sites

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. Go to: github.com/blaze-commerce/claude-wpm/releases            │
│  2. Download: claude-wpm-deploy.zip                                 │
│  3. Upload to Kinsta → Extract to public/                           │
│  4. Start Claude Code                                               │
│  5. Run /init  ← Generates site CLAUDE.md                          │
│  6. Run /wpm   ← Optional: populates plugin inventory               │
└─────────────────────────────────────────────────────────────────────┘
```

**Direct download link:**
```
https://github.com/blaze-commerce/claude-wpm/releases/latest/download/claude-wpm-deploy.zip
```

### What's in the Deploy Zip

```
.claude/
├── CLAUDE-BASE.md     Included   (reusable instructions)
├── README.md          Included   (user documentation)
├── hooks/             Included   (safety hooks)
├── skills/            Included   (specialist prompts)
├── commands/          Included   (CLI commands)
├── scripts/           Included   (maintenance scripts)
├── settings.json      Included   (permissions config)
├── CONTRIBUTING.md    EXCLUDED   (for repo contributors only)
├── qa/                EXCLUDED   (local testing only)
├── plans/             EXCLUDED   (reference docs)
└── cache/             EXCLUDED   (temporary files)
```

**Exclusion rationale:**
- `CONTRIBUTING.md` - For GitHub repo contributors, not end-users
- `qa/` - Runs locally on MacBook, tests live sites via HTTP
- `plans/` - Architecture docs for planning, not runtime
- `cache/` - Temporary files, regenerated as needed

### Creating Releases

**Automatic (GitHub Actions):**
1. Go to GitHub → Releases → Create new release
2. Create tag: `v1.0.1`, `v1.1.0`, etc.
3. Publish → Workflow auto-attaches zip

**Manual (if workflow fails):**
```bash
.claude/scripts/create-deploy-zip.sh 1.0.1
# Upload dist/claude-wpm-deploy-1.0.1.zip to release
```

---

## 4. QA Testing Framework

### Overview

Cross-browser WooCommerce testing using Playwright. Runs **locally on MacBook**, tests **live sites via HTTP**.

```
┌──────────────────┐         HTTPS         ┌──────────────────┐
│  Your MacBook    │ ───────────────────▶  │  Live Kinsta     │
│                  │                       │  Site            │
│  - Playwright    │   Tests run like a    │                  │
│  - qa/ folder    │   real browser user   │  birdbusta.net   │
│  - Node.js       │                       │  WooCommerce     │
└──────────────────┘                       └──────────────────┘
```

### Folder Structure

```
qa/
├── config/
│   └── playwright.config.ts
├── shared/
│   ├── fixtures/
│   │   └── woo-fixtures.ts
│   └── utils/
│       └── selectors.ts
├── sites/
│   ├── birdbusta.net/
│   │   ├── site.config.ts
│   │   ├── test-data.ts
│   │   └── tests/
│   │       ├── shop-page.spec.ts
│   │       ├── single-product.spec.ts
│   │       ├── cart.spec.ts
│   │       └── checkout.spec.ts
│   └── _template/
│       └── ...
├── package.json
├── .env.example
├── .gitignore
└── README.md
```

### Test Commands

```bash
npm test                    # All tests, all browsers
npm run test:chrome         # Chrome only
npm run test:firefox        # Firefox only
npm run test:safari         # Safari only
npm run test:edge           # Edge only
npm run test:headed         # Watch tests run
npm run test:ui             # Interactive UI
npm run report              # View HTML report
```

### Adding a New Site

1. Copy `qa/sites/_template/` to `qa/sites/newsite.com/`
2. Edit `site.config.ts` with URLs
3. Update `test-data.ts` with test products
4. Run: `npm test -- --grep @newsite`

---

## 5. GitHub Pages for Test Reports

### Overview

Test reports are published to GitHub Pages **only after tests pass**. This creates a permanent, shareable record of QA results.

**Report URL:** `https://blaze-commerce.github.io/claude-wpm/`

### The Automated Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│  LOCAL MACBOOK                                                      │
│  ─────────────────────────────────────────────────────────────────  │
│  1. Run tests:        npm test                                      │
│  2. Tests pass?       ✓ Yes → Continue                              │
│                       ✗ No  → Fix issues, do NOT push               │
│  3. Commit & push:    npm run publish-report                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  GITHUB                                                             │
│  ─────────────────────────────────────────────────────────────────  │
│  4. Push triggers:    .github/workflows/deploy-report.yml           │
│  5. Workflow:         Builds report → Deploys to gh-pages branch    │
│  6. Result:           Report visible at GitHub Pages URL            │
└─────────────────────────────────────────────────────────────────────┘
```

### Detailed Workflow

**Step 1: Run Tests Locally**
```bash
cd .claude/qa
npm test                          # Run all tests
# OR
npm run test:chrome -- --grep @birdbusta   # Specific site/browser
```

**Step 2: Review Results**
- Tests generate HTML report in `qa/reports/html/`
- View locally: `npm run report`
- Only proceed if all tests pass

**Step 3: Publish Report (Tests Must Pass)**
```bash
npm run publish-report
```

This script will:
1. Verify tests passed (exit if failures detected)
2. Copy report to `docs/` folder (GitHub Pages source)
3. Commit changes with timestamp
4. Push to main branch
5. GitHub Actions deploys to gh-pages

**Step 4: View Published Report**
- URL: `https://blaze-commerce.github.io/claude-wpm/`
- Report includes: test results, screenshots on failure, trace files

### npm Scripts for Reporting

```json
{
  "scripts": {
    "test": "playwright test",
    "report": "playwright show-report reports/html",
    "publish-report": "./scripts/publish-report.sh"
  }
}
```

### publish-report.sh Script

```bash
#!/bin/bash
# qa/scripts/publish-report.sh

set -e

# Check if tests passed (results.json exists and has no failures)
RESULTS_FILE="reports/results.json"
if [ ! -f "$RESULTS_FILE" ]; then
    echo "Error: No test results found. Run 'npm test' first."
    exit 1
fi

# Check for failures in results
FAILURES=$(jq '.suites[].specs[].tests[].results[].status' "$RESULTS_FILE" 2>/dev/null | grep -c '"failed"' || true)
if [ "$FAILURES" -gt 0 ]; then
    echo "Error: $FAILURES test(s) failed. Fix failures before publishing."
    exit 1
fi

# Copy report to docs folder for GitHub Pages
DOCS_DIR="../../docs/qa-report"
mkdir -p "$DOCS_DIR"
cp -r reports/html/* "$DOCS_DIR/"

# Commit and push
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
cd ../..
git add docs/qa-report
git commit -m "QA Report: $TIMESTAMP - All tests passed"
git push origin main

echo "Report published! View at: https://blaze-commerce.github.io/claude-wpm/"
```

### GitHub Actions Workflow

File: `.github/workflows/deploy-report.yml`

```yaml
name: Deploy QA Report to GitHub Pages

on:
  push:
    branches: [main]
    paths:
      - 'docs/qa-report/**'

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: 'docs/qa-report'

      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v4
```

### GitHub Pages Setup (One-Time)

1. Go to repo Settings → Pages
2. Source: **GitHub Actions**
3. The workflow handles deployment automatically

### Report Structure on GitHub Pages

```
https://blaze-commerce.github.io/claude-wpm/
├── index.html          # Main report dashboard
├── data/               # Test result data
├── trace/              # Playwright traces (on failure)
└── screenshots/        # Failure screenshots
```

---

## 6. Git Conventions

All contributors must follow these standards. Full details in **[CONTRIBUTING.md](../CONTRIBUTING.md)**.

### Branch Naming

| Type | Use For | Example |
|------|---------|---------|
| `feature/` | New functionality | `feature/add-checkout-tests` |
| `fix/` | Bug fixes | `fix/cart-selector-timeout` |
| `hotfix/` | Urgent production fixes | `hotfix/security-patch` |
| `docs/` | Documentation only | `docs/update-readme` |
| `refactor/` | Code restructure | `refactor/simplify-selectors` |
| `test/` | Adding/updating tests | `test/add-safari-coverage` |
| `chore/` | Maintenance | `chore/update-playwright` |

### Commit Messages (Conventional Commits)

Format: `<type>(<scope>): <description>`

| Type | When to Use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting only |
| `refactor` | Code restructure |
| `test` | Tests |
| `chore` | Maintenance |
| `perf` | Performance |
| `ci` | CI/CD changes |

**Scopes:** `qa`, `hooks`, `skills`, `commands`, `scripts`, `readme`, `plans`

**Examples:**
```bash
git commit -m "feat(qa): add checkout flow tests"
git commit -m "fix(hooks): correct wp-config regex"
git commit -m "docs(readme): add Claude install command"
```

### Semantic Versioning

| Version | When | Example |
|---------|------|---------|
| MAJOR | Breaking changes | `v1.0.0` → `v2.0.0` |
| MINOR | New features | `v1.0.0` → `v1.1.0` |
| PATCH | Bug fixes | `v1.0.0` → `v1.0.1` |

### Quick Workflow

```bash
git checkout -b feature/add-new-skill     # Create branch
git commit -m "feat(skills): add X"        # Commit
git push -u origin feature/add-new-skill   # Push
# Create PR on GitHub, merge, then tag for release
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

> **Reminder:** If you forget these conventions, check CONTRIBUTING.md or ask Claude to remind you.

---

## 7. Prompts for Local Claude Code

### Prompt: Create QA Folder Structure

```
Create the qa/ folder structure in .claude/qa/ with:
- config/playwright.config.ts
- shared/utils/selectors.ts
- shared/fixtures/woo-fixtures.ts
- sites/_template/ with example files
- sites/birdbusta.net/ with real config
- package.json with test scripts
- README.md with setup instructions

Reference plans/blaze-qa-test-framework.md for the exact file contents.
```

### Prompt: Run Tests for a Site

```
I want to run E2E tests for birdbusta.net. Please:
1. Navigate to .claude/qa
2. Check if dependencies are installed
3. Run: npm run test:chrome -- --grep @birdbusta
4. Show me the results summary
```

---

## 8. Checklist

### Phase 1: WPM System (Complete)
- [x] Create hooks/ folder with safety hooks
- [x] Create skills/ folder with specialist prompts
- [x] Create commands/ folder
- [x] Create scripts/ folder
- [x] Set up .github/workflows/release.yml
- [x] Create plans/ folder with documentation
- [x] Update README.md with deployment workflows
- [x] Create CONTRIBUTING.md with Git conventions

### Phase 2: QA System Setup
- [ ] Create qa/ folder structure
- [ ] Create config/playwright.config.ts
- [ ] Create shared/utils/selectors.ts
- [ ] Create sites/_template/ for new sites
- [ ] Create sites/birdbusta.net/ with real config
- [ ] Create qa/scripts/publish-report.sh
- [ ] Create docs/qa-report/ folder (for GitHub Pages)

### Phase 3: QA Dependencies & First Run
- [ ] On MacBook: `cd .claude/qa && npm install`
- [ ] Install browsers: `npx playwright install`
- [ ] Update birdbusta.net site.config.ts with real product URLs
- [ ] Run first test: `npm run test:chrome -- --grep @birdbusta`
- [ ] Verify HTML report generates correctly

### Phase 4: GitHub Pages Setup
- [ ] Create .github/workflows/deploy-report.yml
- [ ] Enable GitHub Pages in repo settings (Source: GitHub Actions)
- [ ] Run tests → verify they pass
- [ ] Run `npm run publish-report`
- [ ] Verify report visible at https://blaze-commerce.github.io/claude-wpm/

### Verification Checklist
- [ ] WPM zip does NOT contain qa/ folder
- [ ] QA tests run successfully on local MacBook
- [ ] Tests only publish reports when ALL tests pass
- [ ] GitHub Pages shows latest test report

---

## Quick Reference

### WPM System (For Kinsta Sites)

| Task | Where | Command/Action |
|------|-------|----------------|
| Deploy to new Kinsta site | GitHub | Download zip from Releases |
| Create new release | GitHub | Create release → workflow auto-builds zip |
| Direct download | Browser | `https://github.com/blaze-commerce/claude-wpm/releases/latest/download/claude-wpm-deploy.zip` |

### QA System (Local Only)

| Task | Where | Command/Action |
|------|-------|----------------|
| Run all tests | Local MacBook | `cd .claude/qa && npm test` |
| Run specific browser | Local MacBook | `npm run test:chrome` |
| Run specific site | Local MacBook | `npm test -- --grep @birdbusta` |
| View report locally | Local MacBook | `npm run report` |
| Add new test site | Local MacBook | Copy `sites/_template/` → configure |
| Publish report (after pass) | Local MacBook | `npm run publish-report` |
| View published report | Browser | `https://blaze-commerce.github.io/claude-wpm/`

---

*Last updated: 2026-01-26*
*Version: 2.1 - Added Git conventions section and CONTRIBUTING.md*
*Maintained by: Blaze Commerce*
