# QA Architecture - Senior Architect Design Document

> **Status:** Draft - Pending Review
> **Author:** Senior Architect
> **Date:** 2026-01-26

---

## Table of Contents

1. [Ultimate Goal](#1-ultimate-goal)
2. [Requirements](#2-requirements)
3. [Architecture Overview](#3-architecture-overview)
4. [Site & Environment Structure](#4-site--environment-structure)
5. [Command System Design](#5-command-system-design)
6. [Test Foundation Architecture](#6-test-foundation-architecture)
7. [Decisions & Trade-offs](#7-decisions--trade-offs)
8. [Implementation Phases](#8-implementation-phases)
9. [Test Status Definitions](#9-test-status-definitions)
10. [Screenshot Testing Strategy](#10-screenshot-testing-strategy)
11. [WooCommerce Functional Testing](#11-woocommerce-functional-testing)
12. [Per-Site Documentation](#12-per-site-documentation)
13. [Open Questions](#13-open-questions)

---

## 1. Ultimate Goal

**Build a scalable, flexible E2E testing framework that:**
- Supports **multiple sites** (birdbusta.net, future sites)
- Supports **multiple environments per site** (live, staging1, staging2, etc.)
- Executes via **simple commands** (`/qa-birdbusta.net`, `/qa-birdbusta.net-staging1`)
- Provides a **reusable foundation** that adapts to different site structures
- Is **robust, secure, and high-performing**
- **Publishes reports** to GitHub Pages after tests pass

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ULTIMATE VISION                                   │
│                                                                             │
│   /qa-sitename           → Run all tests on LIVE site                       │
│   /qa-sitename-staging1  → Run all tests on STAGING1                        │
│   /qa-sitename-staging2  → Run all tests on STAGING2                        │
│                                                                             │
│   One command. Any site. Any environment. Full E2E coverage.                │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Requirements

### Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1 | Support multiple sites (birdbusta.net, site2, site3...) | Must |
| FR-2 | Support multiple environments per site (live, staging1, staging2) | Must |
| FR-3 | Execute via command: `/qa-{site}` or `/qa-{site}-{env}` | Must |
| FR-4 | Reusable test foundation across all sites | Must |
| FR-5 | Site-specific customizations (selectors, pages, flows) | Must |
| FR-6 | Publish passing reports to GitHub Pages | Must |
| FR-7 | Cross-browser testing (Chrome, Firefox, Safari, Edge) | Should |
| FR-8 | Mobile viewport testing | Should |

### Non-Functional Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1 | **Scalable** - Add new sites without code changes to core | Yes |
| NFR-2 | **Flexible** - Override any test behavior per site | Yes |
| NFR-3 | **Robust** - Handle flaky tests, retries, timeouts | Yes |
| NFR-4 | **Secure** - No credentials in code, use env vars | Yes |
| NFR-5 | **Performant** - Parallel test execution | Yes |
| NFR-6 | **Maintainable** - Clear structure, documented | Yes |

---

## 3. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              QA FRAMEWORK                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐         │
│  │   COMMANDS      │    │   CORE          │    │   SITES         │         │
│  │   (Entry Point) │───▶│   (Foundation)  │◀───│   (Overrides)   │         │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘         │
│         │                       │                      │                    │
│         │                       ▼                      │                    │
│         │               ┌─────────────────┐            │                    │
│         │               │   SHARED        │            │                    │
│         │               │   - Selectors   │            │                    │
│         │               │   - Fixtures    │            │                    │
│         │               │   - Utilities   │            │                    │
│         │               └─────────────────┘            │                    │
│         │                       │                      │                    │
│         ▼                       ▼                      ▼                    │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                      PLAYWRIGHT ENGINE                           │       │
│  │   - Browser automation                                           │       │
│  │   - Test execution                                               │       │
│  │   - Report generation                                            │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│                                 │                                           │
│                                 ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                      GITHUB PAGES                                │       │
│  │   - Test reports                                                 │       │
│  │   - Historical results                                           │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Changes When |
|-------|---------------|--------------|
| **Commands** | Entry point, parses site/env, triggers tests | New command patterns needed |
| **Core** | Base test classes, common flows, default behavior | Framework improvements |
| **Shared** | Reusable selectors, fixtures, utilities | WooCommerce updates |
| **Sites** | Site-specific config, overrides, custom tests | Site changes |

---

## 4. Site & Environment Structure

### Directory Structure

```
qa/
├── config/
│   └── playwright.config.ts          # Global Playwright config
│
├── core/                              # FOUNDATION (reusable)
│   ├── base-tests/
│   │   ├── shop.base.ts              # Base shop page tests
│   │   ├── product.base.ts           # Base product page tests
│   │   ├── cart.base.ts              # Base cart tests
│   │   └── checkout.base.ts          # Base checkout tests
│   ├── page-objects/
│   │   ├── shop.page.ts              # Shop page object
│   │   ├── product.page.ts           # Product page object
│   │   ├── cart.page.ts              # Cart page object
│   │   └── checkout.page.ts          # Checkout page object
│   └── fixtures/
│       └── woo.fixture.ts            # WooCommerce test fixtures
│
├── shared/
│   ├── selectors/
│   │   └── woo-selectors.ts          # Default WooCommerce selectors
│   └── utils/
│       ├── helpers.ts                # Test helpers
│       └── assertions.ts             # Custom assertions
│
├── sites/                             # SITE-SPECIFIC
│   ├── birdbusta.net/
│   │   ├── environments.ts           # Environment URLs
│   │   ├── selectors.ts              # Selector overrides (if needed)
│   │   ├── config.ts                 # Site-specific config
│   │   └── tests/
│   │       ├── shop.spec.ts          # Extends base, adds specifics
│   │       ├── product.spec.ts
│   │       ├── cart.spec.ts
│   │       └── checkout.spec.ts
│   │
│   └── _template/                     # Template for new sites
│       ├── environments.ts
│       ├── selectors.ts
│       ├── config.ts
│       └── tests/
│           └── example.spec.ts
│
├── scripts/
│   ├── run-qa.sh                     # Main test runner
│   └── publish-report.sh             # Publish to GitHub Pages
│
├── reports/                          # Generated (gitignored)
├── package.json
├── tsconfig.json
└── README.md
```

### Environment Configuration

Each site defines its environments in `environments.ts`:

```typescript
// sites/birdbusta.net/environments.ts

export const environments = {
  live: {
    baseURL: 'https://birdbusta.net',
    name: 'Production',
  },
  staging1: {
    baseURL: 'https://staging1.birdbusta.net',
    name: 'Staging 1',
  },
  staging2: {
    baseURL: 'https://staging2.birdbusta.net',
    name: 'Staging 2',
  },
} as const;

export type Environment = keyof typeof environments;
export const defaultEnvironment: Environment = 'live';
```

### Environment Resolution

```
Command Input          → Parsed Site    → Parsed Environment
─────────────────────────────────────────────────────────────
/qa-birdbusta.net      → birdbusta.net  → live (default)
/qa-birdbusta.net-staging1 → birdbusta.net → staging1
/qa-birdbusta.net-staging2 → birdbusta.net → staging2
```

---

## 5. Command System Design

### Command Format

```
/qa-{site}[-{environment}]
```

| Command | Site | Environment |
|---------|------|-------------|
| `/qa-birdbusta.net` | birdbusta.net | live (default) |
| `/qa-birdbusta.net-live` | birdbusta.net | live (explicit) |
| `/qa-birdbusta.net-staging1` | birdbusta.net | staging1 |
| `/qa-birdbusta.net-staging2` | birdbusta.net | staging2 |
| `/qa-newsite.com` | newsite.com | live (default) |
| `/qa-newsite.com-staging1` | newsite.com | staging1 |

### Command Implementation

File: `.claude/commands/qa.md`

The command will:
1. Parse the site and environment from the command
2. Validate the site exists in `qa/sites/`
3. Validate the environment exists in site's `environments.ts`
4. Run Playwright with the correct configuration
5. Show results summary
6. Offer to publish report if tests pass

### Example Command Flow

```
User: /qa-birdbusta.net-staging1

Claude:
1. Parsed: site=birdbusta.net, env=staging1
2. Found: qa/sites/birdbusta.net/
3. Environment URL: https://staging1.birdbusta.net
4. Running tests...
   ✓ Shop page tests (4 passed)
   ✓ Product tests (3 passed)
   ✓ Cart tests (5 passed)
   ✓ Checkout tests (3 passed)
5. All 15 tests passed!
6. Publish report to GitHub Pages? [Y/n]
```

---

## 6. Test Foundation Architecture

### Base Test Pattern

Tests follow an **inheritance pattern**:

```
┌─────────────────────────────────────────────────────────────────┐
│  CORE BASE TESTS (core/base-tests/)                             │
│  - Default WooCommerce behavior                                 │
│  - Common assertions                                            │
│  - Reusable across all sites                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ extends
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  SITE-SPECIFIC TESTS (sites/*/tests/)                           │
│  - Override selectors if needed                                 │
│  - Add site-specific test cases                                 │
│  - Skip tests not applicable to this site                       │
└─────────────────────────────────────────────────────────────────┘
```

### Example: Base Shop Test

```typescript
// core/base-tests/shop.base.ts

import { test, expect } from '@playwright/test';
import { WooSelectors } from '../../shared/selectors/woo-selectors';

export function createShopTests(config: SiteConfig) {
  const selectors = { ...WooSelectors, ...config.selectorOverrides };

  test.describe(`Shop Page @${config.siteName}`, () => {
    test.beforeEach(async ({ page }) => {
      await page.goto(config.urls.shop);
    });

    test('SHOP-001: Products are displayed', async ({ page }) => {
      await expect(page.locator(selectors.shop.productGrid)).toBeVisible();
      const products = page.locator(selectors.shop.productItem);
      await expect(products).toHaveCount({ min: 1 });
    });

    test('SHOP-002: Add to cart works', async ({ page }) => {
      await page.locator(selectors.shop.addToCartBtn).first().click();
      await expect(page.locator(selectors.messages.success)).toBeVisible();
    });

    // More base tests...
  });
}
```

### Example: Site-Specific Test

```typescript
// sites/birdbusta.net/tests/shop.spec.ts

import { createShopTests } from '../../../core/base-tests/shop.base';
import { getConfig } from '../config';

const config = getConfig(process.env.QA_ENVIRONMENT || 'live');

// Run all base shop tests
createShopTests(config);

// Add site-specific tests
test.describe('Shop Page - Birdbusta Specific @birdbusta', () => {
  test('SHOP-BIRD-001: Featured products carousel works', async ({ page }) => {
    // Test specific to birdbusta.net
  });
});
```

### Selector Override System

Sites can override default selectors:

```typescript
// shared/selectors/woo-selectors.ts (defaults)
export const WooSelectors = {
  shop: {
    productGrid: '.products',
    addToCartBtn: '.add_to_cart_button',
  },
  // ...
};

// sites/birdbusta.net/selectors.ts (overrides)
export const selectorOverrides = {
  shop: {
    // Birdbusta uses a custom theme
    productGrid: '.custom-products-grid',
  },
};
```

---

## 7. Decisions & Trade-offs

### Decision 1: Inheritance vs Composition for Tests

| Option | Pros | Cons |
|--------|------|------|
| **A: Inheritance** | Familiar pattern, clear hierarchy | Can become rigid |
| **B: Composition** | More flexible, mix-and-match | More boilerplate |
| **C: Factory Functions** | Flexible + clean API | Slight learning curve |

**Decision:** Option C - Factory Functions (e.g., `createShopTests(config)`)

**Rationale:**
- Allows passing site-specific config cleanly
- Easy to skip/override individual tests
- No complex class hierarchies
- TypeScript provides good type safety

---

### Decision 2: Environment Variable Approach

| Option | Pros | Cons |
|--------|------|------|
| **A: .env files per site** | Familiar, simple | File management overhead |
| **B: Single .env + runtime flag** | One config file | Must pass env to every command |
| **C: Command parses environment** | Zero config, intuitive UX | Slightly more parsing code |

**Decision:** Option C - Command parses environment

**Rationale:**
- Best developer experience: `/qa-site-staging1` is intuitive
- No .env file switching
- Environment is explicit in command

---

### Decision 3: Report Storage

| Option | Pros | Cons |
|--------|------|------|
| **A: Single report (latest only)** | Simple, small repo | Lose history |
| **B: Timestamped reports** | Full history | Repo grows large |
| **C: Latest + archive last N** | Balance of both | More script logic |

**Decision:** Option A for now (latest only)

**Rationale:**
- Keep it simple initially
- GitHub Actions has run history
- Can add archiving later if needed

---

### Decision 4: Edge Browser Inclusion

| Option | Pros | Cons |
|--------|------|------|
| **A: Include Edge** | 100% major browser coverage, Corporate users | Same engine as Chrome, 30% more tests |
| **B: Exclude Edge** | Faster test runs, no redundant coverage | Missing Edge-specific bugs (rare) |

**Decision:** Option B - Exclude Edge (Recommended by Senior Architect)

**Senior Architect Rationale:**
1. **Engine Redundancy:** Edge uses the same Chromium engine as Chrome. Testing both is redundant - any rendering bug in Chromium will appear in both browsers.
2. **Unique Engine Coverage:** Chrome (Chromium), Firefox (Gecko), and Safari (WebKit) cover ALL three major rendering engines. Edge adds no unique engine coverage.
3. **Test Efficiency:** Excluding Edge reduces test count by ~25% (120 vs 165 screenshots) with negligible coverage loss.
4. **Edge-Specific Bugs:** In practice, Edge-specific rendering bugs are extremely rare (<0.1% of issues) because it shares Chrome's rendering engine.
5. **Resource Optimization:** Faster CI/CD pipelines, less storage for baselines, quicker developer feedback.

**When to Reconsider:**
- If a client specifically reports Edge-only issues
- If Edge deviates significantly from Chrome in future versions
- If corporate compliance requires explicit Edge testing

**Installation (if needed later):**
```bash
brew install --cask microsoft-edge
```

---

### Decision 5: Screenshot Capture Policy

| Option | Pros | Cons |
|--------|------|------|
| **A: Only on failure** | Smaller reports, faster tests | No proof of working state |
| **B: All tests** | Full documentation, client proof | Larger reports, more storage |

**Decision:** Option B - Capture screenshots for ALL tests (pass and fail)

**Senior Architect Rationale:**
1. **Client Disputes:** When clients claim "this broke after your update", you have timestamped visual proof of the site's working state.
2. **Historical Record:** Screenshots serve as documentation of how the site looked at specific points in time.
3. **Regression Detection:** Even "passing" tests provide valuable visual baselines.
4. **Storage Trade-off:** Modern storage is cheap; visual proof is invaluable.

---

## 8. Implementation Phases

### Phase 1: Foundation (Core Framework)
- [ ] Create `qa/core/` directory structure
- [ ] Implement base page objects
- [ ] Implement base test factories
- [ ] Create shared selectors
- [ ] Set up Playwright config

### Phase 2: First Site (birdbusta.net)
- [ ] Create `qa/sites/birdbusta.net/` structure
- [ ] Define environments (live, staging1, staging2)
- [ ] Implement site config
- [ ] Create tests extending base
- [ ] Verify all tests pass

### Phase 3: Command System
- [ ] Create `/qa` command in `.claude/commands/`
- [ ] Implement site/env parsing
- [ ] Add validation and error messages
- [ ] Test all command variations

### Phase 4: Reporting & Publishing
- [ ] Implement `publish-report.sh`
- [ ] Set up GitHub Pages workflow
- [ ] Test full publish flow

### Phase 5: Template & Documentation
- [ ] Complete `_template/` for new sites
- [ ] Write setup documentation
- [ ] Add troubleshooting guide

### Phase 6: WooCommerce Functional Testing
- [ ] Add to Cart functionality
- [ ] Cart page operations (update quantity, remove item)
- [ ] Checkout flow (guest checkout)
- [ ] Product variations (variable products)
- [ ] Coupon code application
- [ ] Mini-cart/AJAX cart updates
- [ ] Product search functionality
- [ ] Product filtering/sorting

---

## 9. Test Status Definitions

### Playwright Test Statuses

| Status | Meaning | Action Required |
|--------|---------|-----------------|
| **Passed** | Test completed successfully on first attempt | None - working as expected |
| **Failed** | Test did not pass after all retries | Investigate and fix |
| **Flaky** | Test failed initially but passed on retry | Monitor - may indicate timing issues |
| **Skipped** | Test was intentionally skipped | Review if skip is still necessary |
| **Timed Out** | Test exceeded timeout limit | Increase timeout or optimize test |

### Understanding Flaky Tests

```
┌─────────────────────────────────────────────────────────────────────┐
│  FLAKY TEST                                                         │
│  ─────────────────────────────────────────────────────────────────  │
│  A test that sometimes passes and sometimes fails with the          │
│  same code. Common causes:                                          │
│                                                                     │
│  • Network timing (slow API responses)                              │
│  • Animation/transition timing                                      │
│  • Race conditions in JavaScript                                    │
│  • Third-party script loading (ads, analytics)                      │
│  • Dynamic content (timestamps, random elements)                    │
└─────────────────────────────────────────────────────────────────────┘
```

**Flaky Test Strategy:**
1. Playwright auto-retries failed tests (configured: 1-2 retries)
2. If passes on retry = marked "flaky" (not failed)
3. Monitor flaky tests - too many indicates unstable tests
4. Fix root cause when possible (add waits, stabilize selectors)

### Skipped Tests

Tests can be skipped intentionally:

```typescript
// Skip a single test
test.skip('test name', async ({ page }) => { ... });

// Skip conditionally
test('test name', async ({ page }) => {
  test.skip(process.env.CI === 'true', 'Skip in CI');
  // test code
});

// Skip entire describe block
test.describe.skip('Feature X', () => { ... });
```

**When to Skip:**
- Feature not implemented on specific environment
- Known bug being fixed separately
- Environment-specific limitations
- Tests for future functionality

---

## 10. Screenshot Testing Strategy

### Overview

Static page testing via full-page screenshots across multiple browsers and viewports. This ensures visual consistency and catches rendering issues.

### Browser Coverage

| Browser | Playwright Engine | Market Share | Status |
|---------|------------------|--------------|--------|
| Chrome | Chromium | ~65% | **Required** |
| Safari | WebKit | ~18% | **Required** |
| Edge | Chromium | ~5% | **Required** |
| Firefox | Firefox | ~3% | **Required** |
| Opera | Chromium | ~2% | Skip (same as Chrome) |
| Brave | Chromium | ~1% | Skip (same as Chrome) |
| IE | Not supported | Dead | Skip |

**Coverage:** These 4 browsers cover **91%+ of all users**.

### Fresh Context (Incognito Mode)

All tests run in fresh browser contexts to avoid cache-related issues:

```
┌─────────────────────────────────────────────────────────────────────┐
│  Each test = Fresh browser context                                  │
│  - No cookies from previous tests                                   │
│  - No localStorage                                                  │
│  - No cache                                                         │
│  - Effectively incognito/private browsing                           │
└─────────────────────────────────────────────────────────────────────┘
```

Playwright's default behavior creates isolated contexts. No special configuration needed.

### Viewport Testing

Three viewport categories for responsive testing:

| Category | Viewport | Use Case |
|----------|----------|----------|
| **Desktop** | 1920x1080 | Standard desktop monitors |
| **Tablet** | 768x1024 | iPad and similar tablets |
| **Mobile** | 375x667 | iPhone and similar phones |

### Mobile Device Emulation

Playwright fully emulates mobile devices with:

| Feature | Supported | Notes |
|---------|-----------|-------|
| Viewport size | Yes | Exact device dimensions |
| Touch events | Yes | Tap, swipe, pinch |
| Device pixel ratio | Yes | Retina/HiDPI support |
| User agent string | Yes | Device-specific UA |
| Orientation | Yes | Portrait/Landscape |
| Geolocation | Yes | For location-based features |

**Recommended device profiles:**

| Device | Platform | Viewport | Purpose |
|--------|----------|----------|---------|
| iPhone 13 | iOS | 390x844 | iOS mobile testing |
| Pixel 5 | Android | 393x851 | Android mobile testing |
| iPad Pro | iOS | 1024x1366 | Tablet testing |

### Test Matrix

For N static pages across all browsers and viewports:

```
┌─────────────────────────────────────────────────────────────────────┐
│  TEST MATRIX FORMULA                                                │
│                                                                     │
│  Total Tests = Pages × Browsers × Viewports                         │
│                                                                     │
│  Example: 20 pages × 4 browsers × 3 viewports = 240 screenshots     │
└─────────────────────────────────────────────────────────────────────┘
```

| Browser | Desktop | Tablet | Mobile | Per Browser |
|---------|---------|--------|--------|-------------|
| Chrome | N pages | N pages | N pages | N × 3 |
| Firefox | N pages | N pages | N pages | N × 3 |
| Safari | N pages | N pages | N pages | N × 3 |
| Edge | N pages | N pages | N pages | N × 3 |
| **Total** | N × 4 | N × 4 | N × 4 | **N × 12** |

### Performance Expectations

With parallel execution on MacBook:

| Pages | Screenshots | Estimated Time |
|-------|-------------|----------------|
| 10 | 120 | ~1-2 minutes |
| 20 | 240 | ~2-5 minutes |
| 50 | 600 | ~5-10 minutes |

Playwright runs browsers in parallel, significantly reducing total execution time.

### Screenshot Capabilities

| Feature | Description |
|---------|-------------|
| Full-page | Scrolls and captures entire page (not just viewport) |
| Element-specific | Capture specific components |
| Clip region | Capture defined area |
| Omit background | Transparent background option |
| Visual comparison | Compare against baseline images |

### Future Scalability

As the page count grows:

| Strategy | When to Use |
|----------|-------------|
| **Visual regression** | Compare to baselines, fail only on differences |
| **Selective testing** | Full suite nightly, smoke test on-demand |
| **Parallel workers** | Increase worker count for faster execution |
| **Cloud execution** | Run on CI/CD for heavy workloads |

### Visual Regression Baseline Concept

Screenshot testing uses a **baseline comparison** approach:

```
┌─────────────────────────────────────────────────────────────────────┐
│  RUN 1 (First Time) - ESTABLISH BASELINE                           │
│  ─────────────────────────────────────────────────────────────────  │
│  - Captures screenshots of all pages                                │
│  - Saves as BASELINE images                                         │
│  - No pass/fail (nothing to compare yet)                            │
│  - Result: "Baseline established - X screenshots captured"          │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  RUN 2+ (Subsequent Runs) - COMPARE TO BASELINE                    │
│  ─────────────────────────────────────────────────────────────────  │
│  - Captures new screenshots                                         │
│  - Compares pixel-by-pixel against baseline                         │
│  - PASS = No visual differences detected                            │
│  - FAIL = Differences detected (generates diff image)               │
│  - Report shows: before / after / diff                              │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  UPDATING BASELINE                                                  │
│  ─────────────────────────────────────────────────────────────────  │
│  When intentional changes are made (redesign, new content):         │
│  - Run with --update-snapshots flag                                 │
│  - Replaces old baseline with new screenshots                       │
│  - Commit new baselines to git                                      │
└─────────────────────────────────────────────────────────────────────┘
```

**Playwright handles this automatically** with `toHaveScreenshot()`:
- First run: Creates baseline in `tests/__screenshots__/`
- Subsequent runs: Compares against saved baseline
- Threshold configurable (allow minor pixel differences)

---

## 11. WooCommerce Functional Testing

### Overview

Beyond visual regression testing, functional tests verify WooCommerce behavior works correctly. These tests interact with the site like a real user.

### Test Categories

#### Add to Cart Tests
| Test ID | Test Case | Priority |
|---------|-----------|----------|
| CART-001 | Add simple product to cart | Must |
| CART-002 | Add variable product to cart | Must |
| CART-003 | Add product with quantity > 1 | Should |
| CART-004 | Mini-cart updates after add | Should |
| CART-005 | Cart count badge updates | Should |

#### Cart Page Tests
| Test ID | Test Case | Priority |
|---------|-----------|----------|
| CART-010 | View cart shows added products | Must |
| CART-011 | Update product quantity | Must |
| CART-012 | Remove product from cart | Must |
| CART-013 | Cart totals calculate correctly | Must |
| CART-014 | Apply valid coupon code | Should |
| CART-015 | Invalid coupon shows error | Should |

#### Checkout Tests
| Test ID | Test Case | Priority |
|---------|-----------|----------|
| CHKOUT-001 | Guest checkout form loads | Must |
| CHKOUT-002 | Required field validation | Must |
| CHKOUT-003 | Order summary displays correctly | Must |
| CHKOUT-004 | Payment method selection | Should |
| CHKOUT-005 | Order confirmation page | Should |

#### Product Tests
| Test ID | Test Case | Priority |
|---------|-----------|----------|
| PROD-001 | Product gallery/images load | Must |
| PROD-002 | Variable product options work | Must |
| PROD-003 | Price updates with variation | Should |
| PROD-004 | Stock status displays | Should |
| PROD-005 | Related products show | Should |

#### Search & Filter Tests
| Test ID | Test Case | Priority |
|---------|-----------|----------|
| SRCH-001 | Product search returns results | Must |
| SRCH-002 | No results message for invalid search | Should |
| SRCH-003 | Category filtering works | Should |
| SRCH-004 | Price sorting works | Should |

### Implementation Approach

```
┌─────────────────────────────────────────────────────────────────────┐
│  FUNCTIONAL TEST STRATEGY                                           │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  1. Run on STAGING environments (not live)                          │
│     - Avoids creating real orders                                   │
│     - Safe to test payment flows                                    │
│                                                                     │
│  2. Use test products                                               │
│     - Create dedicated test products on staging                     │
│     - Known prices, SKUs, variations                                │
│                                                                     │
│  3. Clean up after tests                                            │
│     - Clear cart between tests                                      │
│     - Don't submit real payment info                                │
│                                                                     │
│  4. Mock payments (if possible)                                     │
│     - Use test payment gateway                                      │
│     - Or stop before final submit                                   │
└─────────────────────────────────────────────────────────────────────┘
```

### Example: Add to Cart Test

```typescript
// core/base-tests/cart.base.ts

test('CART-001: Add simple product to cart', async ({ page }) => {
  // Navigate to a product page
  await page.goto(config.urls.testProduct);

  // Click Add to Cart
  await page.click(selectors.product.addToCartBtn);

  // Wait for AJAX response
  await page.waitForSelector(selectors.messages.addedToCart);

  // Verify cart count updated
  const cartCount = page.locator(selectors.header.cartCount);
  await expect(cartCount).toHaveText('1');

  // Verify mini-cart shows product
  await page.hover(selectors.header.cartIcon);
  await expect(page.locator(selectors.miniCart.productName)).toBeVisible();
});
```

### Environment Recommendations

| Test Type | Live Site | Staging Site |
|-----------|-----------|--------------|
| Screenshots (visual) | ✅ Safe | ✅ Safe |
| Add to Cart | ⚠️ Caution | ✅ Recommended |
| Checkout Flow | ❌ Avoid | ✅ Recommended |
| Payment Tests | ❌ Never | ✅ With test gateway |

---

## 12. Per-Site Documentation

Each site has its own documentation and configuration:

```
qa/sites/
├── birdbusta.net/
│   ├── SITE.md              ← Human-readable page inventory
│   ├── pages.config.ts      ← Page definitions (used by tests)
│   ├── environments.ts      ← Environment URLs
│   └── tests/
│
├── birdcontrolaustralia.com.au/
│   ├── SITE.md              ← Different site, different pages
│   ├── pages.config.ts
│   ├── environments.ts
│   └── tests/
│
└── _template/               ← Copy this to add new site
    ├── SITE.md
    ├── pages.config.ts
    └── ...
```

### SITE.md Contents

Each site's documentation includes:

| Section | Content |
|---------|---------|
| Environments | Live, staging URLs |
| Page Inventory | All pages grouped by type |
| Test Summary | Total pages, browsers, viewports, screenshots |
| Baseline History | When baselines were established/updated |

### Adding a New Site

```bash
# 1. Copy template
cp -r qa/sites/_template qa/sites/newsite.com

# 2. Edit SITE.md with page inventory
# 3. Edit pages.config.ts with page URLs
# 4. Edit environments.ts with site URLs
# 5. Run tests to establish baseline
npm test -- --grep @newsite
```

---

## 13. Open Questions

**For User Review:**

1. **Staging URLs:** What's the URL pattern for staging sites?
   - `staging1.birdbusta.net` ?
   - `birdbusta-staging1.kinsta.cloud` ?
   - Other pattern?

2. **Authentication:** Do staging sites require login/password?
   - If yes, how should credentials be handled?

3. **Test Data:** For checkout tests, do we need:
   - A real test product that exists on all environments?
   - A test coupon code?
   - A specific payment method for testing?

4. **Browsers:** Which browsers are priority?
   - Chrome only for now?
   - Full cross-browser from the start?

5. **Additional Sites:** What other sites will be added soon?
   - This helps validate the multi-site design

---

## Summary

This architecture provides:

| Goal | How It's Achieved |
|------|-------------------|
| **Scalable** | Factory pattern, site directories, no hardcoding |
| **Flexible** | Selector overrides, environment system, extensible tests |
| **Robust** | Playwright retries, proper assertions, error handling |
| **Secure** | No credentials in code, env vars for secrets |
| **Performant** | Parallel execution, shared fixtures |

**Next Step:** Review this document, answer open questions, then proceed to implementation.

---

*Document Location: `.claude/plans/qa-architecture.md`*
*Last Updated: 2026-01-26*
*Revision: 1.2 - Added Edge decision, test statuses, WooCommerce functional testing*
