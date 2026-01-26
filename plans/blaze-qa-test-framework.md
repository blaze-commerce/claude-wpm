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
    "report": "playwright show-report"
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

### 12. `README.md` (for qa folder)

```markdown
# Blaze QA - WooCommerce E2E Tests

Cross-browser testing for WooCommerce sites using Playwright.

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
| `npm run report` | View HTML report |

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

*See the main plan document for complete workflow documentation.*
