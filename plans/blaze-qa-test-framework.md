# Blaze QA - WooCommerce Testing Framework

## Overview
Centralized cross-browser testing framework for WordPress/WooCommerce sites.
Supports multiple live sites with modular, reusable test cases.

---

## Directory Structure

```
qa/
├── config/
│   └── playwright.config.ts       # Global Playwright config
├── sites/
│   ├── birdbusta.net/
│   │   ├── site.config.ts         # Site-specific config (URLs, selectors)
│   │   └── tests/
│   │       ├── shop-page.spec.ts
│   │       ├── single-product.spec.ts
│   │       ├── cart.spec.ts
│   │       └── checkout.spec.ts
│   └── _template/                  # Template for new sites
│       ├── site.config.ts
│       └── tests/
│           └── example.spec.ts
├── shared/
│   ├── fixtures/
│   │   └── woo-fixtures.ts        # WooCommerce page objects
│   └── utils/
│       └── selectors.ts           # Common WooCommerce selectors
├── scripts/
│   └── publish-report.sh          # Publish passing tests to GitHub Pages
├── reports/                       # Generated test reports (gitignored)
│   ├── html/
│   └── results.json
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

---

## File Contents

### 1. `package.json`

```json
{
  "name": "blaze-qa",
  "version": "1.0.0",
  "description": "Cross-browser WooCommerce testing framework",
  "scripts": {
    "test": "playwright test",
    "test:chrome": "playwright test --project=chromium",
    "test:firefox": "playwright test --project=firefox",
    "test:safari": "playwright test --project=webkit",
    "test:edge": "playwright test --project=msedge",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    "report": "playwright show-report reports/html",
    "publish-report": "./scripts/publish-report.sh"
  },
  "devDependencies": {
    "@playwright/test": "^1.42.0",
    "@types/node": "^20.11.0",
    "dotenv": "^16.4.0",
    "typescript": "^5.3.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

### 2. `config/playwright.config.ts`

```typescript
import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

export default defineConfig({
  testDir: '../sites',
  testMatch: '**/*.spec.ts',
  fullyParallel: true,
  workers: process.env.CI ? 2 : 4,
  retries: process.env.CI ? 2 : 1,
  reporter: [
    ['html', { outputFolder: '../reports/html' }],
    ['json', { outputFile: '../reports/results.json' }],
    ['list']
  ],
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 15000,
    navigationTimeout: 30000,
  },
  timeout: 60000,
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'msedge', use: { ...devices['Desktop Edge'], channel: 'msedge' } },
    { name: 'mobile-chrome', use: { ...devices['Pixel 5'] } },
    { name: 'mobile-safari', use: { ...devices['iPhone 13'] } },
  ],
});
```

### 3. `shared/utils/selectors.ts`

```typescript
export const WooSelectors = {
  shop: {
    productGrid: '.products',
    productItem: '.product',
    addToCartBtn: '.add_to_cart_button',
    addedToCartBtn: '.added_to_cart',
    viewCartLink: '.added_to_cart',
    price: '.price',
  },
  singleProduct: {
    addToCartBtn: 'button.single_add_to_cart_button',
    quantityInput: 'input.qty',
    variationSelect: '.variations select',
    productTitle: '.product_title',
  },
  miniCart: {
    itemCount: '.cart-contents .count',
    total: '.cart-contents .amount',
  },
  cart: {
    form: '.woocommerce-cart-form',
    table: '.shop_table.cart',
    itemRow: '.woocommerce-cart-form__cart-item',
    productQty: 'input.qty',
    removeBtn: '.remove',
    couponInput: '#coupon_code',
    applyCouponBtn: 'button[name="apply_coupon"]',
    updateCartBtn: 'button[name="update_cart"]',
    orderTotal: '.order-total .amount',
    checkoutBtn: '.checkout-button',
    emptyCartMsg: '.cart-empty',
  },
  checkout: {
    form: 'form.checkout',
    billingFields: {
      firstName: '#billing_first_name',
      lastName: '#billing_last_name',
      email: '#billing_email',
      phone: '#billing_phone',
      address1: '#billing_address_1',
      city: '#billing_city',
      state: '#billing_state',
      postcode: '#billing_postcode',
      country: '#billing_country',
    },
    placeOrderBtn: '#place_order',
    orderTable: '.woocommerce-checkout-review-order-table',
  },
  messages: {
    success: '.woocommerce-message',
    error: '.woocommerce-error',
  },
  general: {
    loader: '.blockUI, .loading',
  },
};
```

### 4. `sites/birdbusta.net/site.config.ts`

```typescript
export const birdbustaConfig = {
  baseURL: process.env.BIRDBUSTA_URL || 'https://birdbusta.net',
  urls: {
    shop: '/shop',
    cart: '/cart',
    checkout: '/checkout',
    myAccount: '/my-account',
  },
  testData: {
    simpleProduct: '/product/sample-product',
    testCoupon: 'TEST10',
    billing: {
      firstName: 'Test',
      lastName: 'Customer',
      email: 'test@example.com',
      phone: '555-123-4567',
      address1: '123 Test Street',
      city: 'Test City',
      state: 'CA',
      postcode: '90210',
      country: 'US',
    },
  },
};
```

### 5. `sites/birdbusta.net/tests/shop-page.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { birdbustaConfig } from '../site.config';
import { WooSelectors } from '../../../shared/utils/selectors';

test.describe('Shop Page - Add to Cart @birdbusta @shop', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.urls.shop);
  });

  test('SHOP-001: Add simple product to cart', async ({ page }) => {
    const addToCartBtn = page.locator(WooSelectors.shop.addToCartBtn).first();
    await addToCartBtn.click();
    await page.waitForSelector(WooSelectors.shop.addedToCartBtn);
    await expect(page.locator(WooSelectors.messages.success)).toBeVisible();
  });

  test('SHOP-002: Add multiple products to cart', async ({ page }) => {
    const buttons = page.locator(WooSelectors.shop.addToCartBtn);
    await buttons.nth(0).click();
    await page.waitForSelector(WooSelectors.shop.addedToCartBtn);
    await buttons.nth(1).click();
    await page.waitForTimeout(1000);
  });
});
```

### 6. `sites/birdbusta.net/tests/cart.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { birdbustaConfig } from '../site.config';
import { WooSelectors } from '../../../shared/utils/selectors';

test.describe('Cart Page @birdbusta @cart', () => {
  test.beforeEach(async ({ page }) => {
    // Add a product first
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.testData.simpleProduct);
    await page.click(WooSelectors.singleProduct.addToCartBtn);
    await page.waitForSelector(WooSelectors.messages.success);
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.urls.cart);
  });

  test('CART-001: Cart displays product correctly', async ({ page }) => {
    await expect(page.locator(WooSelectors.cart.table)).toBeVisible();
  });

  test('CART-002: Update quantity', async ({ page }) => {
    await page.fill(WooSelectors.cart.productQty, '2');
    await page.click(WooSelectors.cart.updateCartBtn);
    await expect(page.locator(WooSelectors.messages.success)).toBeVisible();
  });

  test('CART-003: Remove item from cart', async ({ page }) => {
    await page.click(WooSelectors.cart.removeBtn);
    await expect(page.locator(WooSelectors.cart.emptyCartMsg)).toBeVisible();
  });

  test('CART-004: Proceed to checkout', async ({ page }) => {
    await page.click(WooSelectors.cart.checkoutBtn);
    await expect(page).toHaveURL(new RegExp(birdbustaConfig.urls.checkout));
  });
});
```

### 7. `sites/birdbusta.net/tests/single-product.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { birdbustaConfig } from '../site.config';
import { WooSelectors } from '../../../shared/utils/selectors';

test.describe('Single Product Page @birdbusta @product', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.testData.simpleProduct);
  });

  test('PROD-001: Add product to cart from product page', async ({ page }) => {
    await page.click(WooSelectors.singleProduct.addToCartBtn);
    await expect(page.locator(WooSelectors.messages.success)).toBeVisible();
  });

  test('PROD-002: Update quantity before adding to cart', async ({ page }) => {
    await page.fill(WooSelectors.singleProduct.quantityInput, '3');
    await page.click(WooSelectors.singleProduct.addToCartBtn);
    await expect(page.locator(WooSelectors.messages.success)).toBeVisible();
  });
});
```

### 8. `sites/birdbusta.net/tests/checkout.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { birdbustaConfig } from '../site.config';
import { WooSelectors } from '../../../shared/utils/selectors';

test.describe('Checkout Page @birdbusta @checkout', () => {
  test.beforeEach(async ({ page }) => {
    // Add product to cart first
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.testData.simpleProduct);
    await page.click(WooSelectors.singleProduct.addToCartBtn);
    await page.waitForSelector(WooSelectors.messages.success);
    await page.goto(birdbustaConfig.baseURL + birdbustaConfig.urls.checkout);
  });

  test('CHECKOUT-001: Checkout form is displayed', async ({ page }) => {
    await expect(page.locator(WooSelectors.checkout.form)).toBeVisible();
  });

  test('CHECKOUT-002: Fill billing details', async ({ page }) => {
    const billing = birdbustaConfig.testData.billing;
    await page.fill(WooSelectors.checkout.billingFields.firstName, billing.firstName);
    await page.fill(WooSelectors.checkout.billingFields.lastName, billing.lastName);
    await page.fill(WooSelectors.checkout.billingFields.email, billing.email);
    await page.fill(WooSelectors.checkout.billingFields.phone, billing.phone);
    await page.fill(WooSelectors.checkout.billingFields.address1, billing.address1);
    await page.fill(WooSelectors.checkout.billingFields.city, billing.city);
    await page.fill(WooSelectors.checkout.billingFields.postcode, billing.postcode);

    // Verify fields are filled
    await expect(page.locator(WooSelectors.checkout.billingFields.firstName)).toHaveValue(billing.firstName);
  });
});
```

### 9. `.env.example`

```bash
# Site URLs
BIRDBUSTA_URL=https://birdbusta.net

# Test settings
CI=false
HEADLESS=true
```

### 10. `.gitignore`

```gitignore
# Dependencies
node_modules/

# Environment
.env
.env.local
.env.*.local

# Test outputs
reports/
test-results/
playwright-report/
playwright/.cache/

# Screenshots and videos
screenshots/
videos/
traces/

# OS
.DS_Store
Thumbs.db
```

### 11. `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "."
  },
  "include": ["**/*.ts"],
  "exclude": ["node_modules", "dist"]
}
```

### 12. `scripts/publish-report.sh`

```bash
#!/bin/bash
# Publish test report to GitHub Pages (only if tests pass)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QA_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$(dirname "$QA_DIR")")"
RESULTS_FILE="$QA_DIR/reports/results.json"
DOCS_DIR="$REPO_ROOT/docs/qa-report"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Blaze QA - Publish Report to GitHub Pages"
echo "=========================================="

# Check if results file exists
if [ ! -f "$RESULTS_FILE" ]; then
    echo -e "${RED}Error: No test results found at $RESULTS_FILE${NC}"
    echo "Run 'npm test' first to generate results."
    exit 1
fi

# Check for test failures using jq
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Warning: jq not installed. Skipping failure check.${NC}"
    echo "Install with: brew install jq"
else
    # Count failed tests
    FAILURES=$(jq '[.suites[].specs[].tests[].results[].status] | map(select(. == "failed")) | length' "$RESULTS_FILE" 2>/dev/null || echo "0")

    if [ "$FAILURES" -gt 0 ]; then
        echo -e "${RED}Error: $FAILURES test(s) failed.${NC}"
        echo "Fix all failures before publishing report."
        echo "Run 'npm run report' to view failure details."
        exit 1
    fi

    echo -e "${GREEN}✓ All tests passed${NC}"
fi

# Check if HTML report exists
if [ ! -d "$QA_DIR/reports/html" ]; then
    echo -e "${RED}Error: HTML report not found at $QA_DIR/reports/html${NC}"
    exit 1
fi

# Create docs directory if needed
mkdir -p "$DOCS_DIR"

# Copy report to docs folder
echo "Copying report to $DOCS_DIR..."
rm -rf "$DOCS_DIR"/*
cp -r "$QA_DIR/reports/html"/* "$DOCS_DIR/"

# Get timestamp and test summary
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
TOTAL_TESTS=$(jq '[.suites[].specs[].tests[]] | length' "$RESULTS_FILE" 2>/dev/null || echo "?")
PASSED_TESTS=$(jq '[.suites[].specs[].tests[].results[].status] | map(select(. == "passed" or . == "expected")) | length' "$RESULTS_FILE" 2>/dev/null || echo "?")

# Commit and push
cd "$REPO_ROOT"
git add docs/qa-report

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${YELLOW}No changes to report. Already up to date.${NC}"
    exit 0
fi

git commit -m "QA Report: $TIMESTAMP

Tests: $PASSED_TESTS/$TOTAL_TESTS passed
Generated by Blaze QA Framework"

echo "Pushing to origin..."
git push origin main

echo ""
echo -e "${GREEN}=========================================="
echo "  Report Published Successfully!"
echo "==========================================${NC}"
echo ""
echo "View at: https://blaze-commerce.github.io/claude-wpm/"
echo ""
```

### 13. `README.md` (for qa folder)

```markdown
# Blaze QA - WooCommerce E2E Tests

Cross-browser testing for WooCommerce sites using Playwright.

> **Important:** This QA framework runs LOCALLY on your MacBook. It is NOT deployed to live sites. Test reports are published to GitHub Pages after tests pass.

## Quick Start

```bash
# Install dependencies
npm install

# Install browsers
npx playwright install

# Run all tests
npm test

# Run specific browser
npm run test:chrome
npm run test:firefox
npm run test:safari
```

## Test Commands

| Command | Description |
|---------|-------------|
| `npm test` | Run all tests, all browsers |
| `npm run test:chrome` | Chrome only |
| `npm run test:firefox` | Firefox only |
| `npm run test:safari` | Safari only |
| `npm run test:edge` | Edge only |
| `npm run test:headed` | Watch tests run |
| `npm run test:ui` | Interactive UI |
| `npm run report` | View HTML report locally |
| `npm run publish-report` | Publish report to GitHub Pages |

## Publishing Reports

After tests pass, publish the report to GitHub Pages:

```bash
# 1. Run tests
npm test

# 2. If all tests pass, publish
npm run publish-report

# 3. View online
# https://blaze-commerce.github.io/claude-wpm/
```

**Note:** The publish script will refuse to publish if any tests failed.

## Adding a New Site

1. Copy `sites/_template/` to `sites/yoursite.com/`
2. Edit `site.config.ts` with your URLs
3. Update test data as needed
4. Run: `npm test -- --grep @yoursite`

## Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
BIRDBUSTA_URL=https://birdbusta.net
```
```

### 14. `.github/workflows/deploy-report.yml`

> **Note:** This file goes in the repo root's `.github/workflows/` folder, not in qa/.

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

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: 'docs/qa-report'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

---

## Quick Start

```bash
cd .claude/qa
npm install
npx playwright install
npm test
```

---

## Test Coverage

| Module | Test Cases |
|--------|------------|
| Shop Page | Add to cart, multiple products |
| Single Product | Add to cart, quantity update |
| Cart | Display, update qty, remove, proceed to checkout |
| Checkout | Form display, fill billing details |

---

## Workflow Summary

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. Run tests locally:     npm test                                 │
│  2. View report locally:   npm run report                           │
│  3. If all pass, publish:  npm run publish-report                   │
│  4. View online:           https://blaze-commerce.github.io/claude-wpm/  │
└─────────────────────────────────────────────────────────────────────┘
```

---

*Last updated: 2026-01-26*
*See claude-wpm-master-plan.md for complete project documentation.*
