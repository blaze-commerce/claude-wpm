# Claude-WPM Master Plan

> **Purpose:** Complete documentation of the claude-wpm repository structure, deployment workflow, and QA testing framework. Reference this document to avoid repeating discussions.

---

## Table of Contents

1. [Repository Overview](#1-repository-overview)
2. [Current State vs Planned State](#2-current-state-vs-planned-state)
3. [Deployment Workflow](#3-deployment-workflow)
4. [QA Testing Framework](#4-qa-testing-framework)
5. [GitHub Pages for Test Reports](#5-github-pages-for-test-reports)
6. [Prompts for Local Claude Code](#6-prompts-for-local-claude-code)
7. [Checklist](#7-checklist)

---

## 1. Repository Overview

**Repo:** `git@github.com:blaze-commerce/claude-wpm.git`

### Purpose
Reusable Claude Code configuration for WordPress/WooCommerce sites hosted on Kinsta.

### The Golden Rule

```
┌─────────────────────────────────────────────────────────────────────┐
│  LIVE SITES (Kinsta):  hooks/ + skills/ + commands/ + scripts/     │
│  LOCAL MACHINE ONLY:   qa/                                          │
└─────────────────────────────────────────────────────────────────────┘
```

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
│   │   └── database-administrator.md
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

| Component | Current State | Planned State | Action Needed |
|-----------|---------------|---------------|---------------|
| hooks/ | Done | Done | None |
| skills/ | Done | Done | None |
| commands/ | Done | Done | None |
| scripts/ | Done | Done | None |
| .github/workflows/release.yml | Done | Done | Fix location if needed |
| **plans/** | Done | Done | Created via this prompt |
| **qa/** | Not created | Planned | Create folder + files |
| **README.md** | Updated | Done | Updated via this prompt |

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
├── CLAUDE-BASE.md     Included
├── README.md          Included
├── hooks/             Included
├── skills/            Included
├── commands/          Included
├── scripts/           Included
├── settings.json      Included
├── qa/                EXCLUDED
├── plans/             EXCLUDED
└── cache/             EXCLUDED
```

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

### How It Works

After running tests locally, push reports to GitHub → View in browser.

```
Run tests → Generate report → Push to gh-pages → View online
```

**URL:** `https://blaze-commerce.github.io/claude-wpm/`

### Workflow Options

**Option A: Manual Push**
```bash
# After running tests
npm test
# Push report to gh-pages branch
npm run publish-report
```

**Option B: GitHub Actions (Automated)**
- Tests run on schedule or push
- Reports auto-publish to GitHub Pages

---

## 6. Prompts for Local Claude Code

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

## 7. Checklist

### Immediate Actions
- [x] Update README.md with deployment workflows
- [x] Create plans/ folder with documentation
- [ ] Create qa/ folder with Playwright tests (when ready)
- [ ] Verify GitHub Release workflow works

### When Ready for QA Testing
- [ ] Create qa/ folder structure
- [ ] On MacBook: `cd .claude/qa && npm install && npx playwright install`
- [ ] Update `sites/birdbusta.net/site.config.ts` with real product URLs
- [ ] Run first test: `npm run test:chrome`

### Optional: GitHub Pages for Reports
- [ ] Add test-report workflow
- [ ] Enable GitHub Pages in repo settings (gh-pages branch)
- [ ] Run tests and publish report

---

## Quick Reference

| Task | Where | Command/Action |
|------|-------|----------------|
| Deploy to new Kinsta site | GitHub | Download from Releases |
| Create new release | GitHub | Create release → workflow auto-builds zip |
| Run QA tests | Local MacBook | `cd .claude/qa && npm test` |
| View test report | Local MacBook | `npm run report` |
| Add new test site | Local MacBook | Copy `_template/` → configure |
| Publish report online | GitHub | Push to gh-pages or run workflow |

---

*Last updated: 2026-01-26*
*Maintained by: Blaze Commerce*
