# Blaze QA - Visual Regression Testing Framework

Cross-browser screenshot testing for WooCommerce sites using Playwright.

> **Important:** This QA framework runs LOCALLY on your MacBook. It is NOT deployed to live sites. Test reports can be published to GitHub Pages after tests pass.

---

## Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Install browsers
npx playwright install

# 3. Run all tests (first run = establish baseline)
npm test

# 4. View report
npm run report
```

---

## Test Commands

| Command | Description |
|---------|-------------|
| `npm test` | Run all tests, all browsers, all viewports |
| `npm run test:chrome` | Chrome only |
| `npm run test:firefox` | Firefox only |
| `npm run test:safari` | Safari (WebKit) only |
| `npm run test:edge` | Edge only |
| `npm run test:headed` | Watch tests run visually |
| `npm run test:ui` | Interactive Playwright UI |
| `npm run test:update-baseline` | Update baseline screenshots |
| `npm run report` | View HTML report |
| `npm run publish-report` | Publish to GitHub Pages |

---

## Running Tests for Specific Sites

```bash
# Run all tests for birdbusta.net
npm test -- --grep @birdbusta

# Run only static page tests
npm test -- --grep @static

# Run only product page tests
npm test -- --grep @product

# Combine filters
npm test -- --grep "@birdbusta.*@product"
```

---

## How Baseline Screenshots Work

```
┌─────────────────────────────────────────────────────────────────────┐
│  FIRST RUN                                                          │
│  - Captures screenshots                                             │
│  - Saves as BASELINE (in __screenshots__ folders)                   │
│  - No pass/fail (nothing to compare)                                │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  SUBSEQUENT RUNS                                                    │
│  - Captures new screenshots                                         │
│  - Compares against baseline                                        │
│  - PASS = No visual differences                                     │
│  - FAIL = Differences detected (shows diff image)                   │
└─────────────────────────────────────────────────────────────────────┘
```

### Updating Baselines

After intentional design changes:

```bash
# Update all baselines
npm run test:update-baseline

# Update baselines for specific site
npm run test:update-baseline -- --grep @birdbusta
```

---

## Test Coverage

### Browsers (4)

| Browser | Engine | Project Names | Notes |
|---------|--------|---------------|-------|
| Chrome | Chromium | chrome-desktop, chrome-tablet, chrome-mobile | Full support |
| Firefox | Gecko | firefox-desktop, firefox-tablet | No mobile (Playwright limitation) |
| Safari | WebKit | safari-desktop, safari-tablet, safari-mobile | Full support |
| Edge | Chromium | edge-desktop, edge-tablet, edge-mobile | Requires Edge installed |

### Viewports (3)

| Viewport | Dimensions | Description |
|----------|------------|-------------|
| Desktop | 1920 × 1080 | Standard desktop monitor |
| Tablet | 768 × 1024 | iPad-sized tablet |
| Mobile | 375 × 667 | iPhone-sized mobile |

### Sites

| Site | Tag | Pages | Screenshots | Notes |
|------|-----|-------|-------------|-------|
| birdbusta.net | @birdbusta | 15 | ~113 | Chrome + Firefox + Safari |

> **Note:** Firefox-mobile is excluded (Playwright limitation). Edge requires Microsoft Edge to be installed (`brew install --cask microsoft-edge`).

---

## Adding a New Site

```bash
# 1. Copy template
cp -r sites/_template sites/newsite.com

# 2. Edit the files:
#    - SITE.md (documentation)
#    - environments.ts (URLs)
#    - pages.config.ts (page inventory)
#    - config.ts (site name and tag)
#    - tests/screenshot.spec.ts (update @tag)

# 3. Run tests to establish baseline
npm test -- --grep @newsite
```

---

## Directory Structure

```
qa/
├── config/
│   └── playwright.config.ts    # Browser and viewport configuration
├── shared/
│   ├── selectors/              # WooCommerce selectors
│   └── utils/                  # Helper functions
├── sites/
│   ├── birdbusta.net/
│   │   ├── SITE.md             # Site documentation
│   │   ├── environments.ts     # URLs for live/staging
│   │   ├── pages.config.ts     # Page inventory
│   │   ├── config.ts           # Site configuration
│   │   └── tests/
│   │       └── screenshot.spec.ts
│   └── _template/              # Copy this for new sites
├── reports/                    # Generated reports (gitignored)
├── package.json
└── README.md
```

---

## Troubleshooting

### Tests are being rate-limited

Reduce parallel workers:
```bash
# In .env
WORKERS=2
```

### Screenshots differ slightly (anti-aliasing)

Adjust threshold in playwright.config.ts:
```typescript
expect: {
  toHaveScreenshot: {
    maxDiffPixelRatio: 0.01, // Allow 1% difference
  },
}
```

### Cookie banners appearing in screenshots

The framework automatically hides common cookie banners. If yours isn't hidden, add the selector to `shared/utils/helpers.ts` in the `hideCookieBanners` function.

### My Account page fails

The WooCommerce My Account page redirects to login when not authenticated, causing timing issues. This is expected behavior. To test the logged-in My Account page, you would need to implement authentication fixtures.

### Contact page fails on Safari

Contact pages with forms may have slow-loading elements on Safari WebKit. Try increasing the timeout or exclude from Safari tests if consistently failing.

---

## Documentation

| Document | Location |
|----------|----------|
| Architecture | `.claude/plans/qa-architecture.md` |
| Implementation Details | `.claude/plans/blaze-qa-test-framework.md` |
| Master Plan | `.claude/plans/claude-wpm-master-plan.md` |

---

*Last Updated: 2026-01-26*
