/**
 * Screenshot Tests for [SITE_NAME]
 *
 * INSTRUCTIONS:
 * 1. Update the import paths if you renamed files
 * 2. Update the @[SITE_TAG] in test.describe to match your siteTag
 * 3. Run: npm test -- --grep @[SITE_TAG]
 */

import { test, expect } from '@playwright/test';
import { getSiteConfig } from '../config';
import { staticPages, wooPages, productPages } from '../pages.config';
import { prepareForScreenshot, pathToFilename } from '../../../shared/utils/helpers';

const config = getSiteConfig();

// ============================================================================
// STATIC PAGES
// ============================================================================

test.describe(`Static Pages @[SITE_TAG] @static`, () => {
  for (const page of staticPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      await browserPage.goto(`${config.baseURL}${page.path}`);
      await prepareForScreenshot(browserPage);

      await expect(browserPage).toHaveScreenshot(
        `static/${pathToFilename(page.path)}.png`,
        { fullPage: true, animations: 'disabled' }
      );
    });
  }
});

// ============================================================================
// WOOCOMMERCE CORE PAGES
// ============================================================================

test.describe(`WooCommerce Pages @[SITE_TAG] @woo`, () => {
  for (const page of wooPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      await browserPage.goto(`${config.baseURL}${page.path}`);
      await prepareForScreenshot(browserPage);

      await expect(browserPage).toHaveScreenshot(
        `woo/${pathToFilename(page.path)}.png`,
        { fullPage: true, animations: 'disabled' }
      );
    });
  }
});

// ============================================================================
// PRODUCT PAGES
// ============================================================================

test.describe(`Product Pages @[SITE_TAG] @product`, () => {
  for (const page of productPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      await browserPage.goto(`${config.baseURL}${page.path}`);
      await prepareForScreenshot(browserPage);

      await expect(browserPage).toHaveScreenshot(
        `products/${pathToFilename(page.path)}.png`,
        { fullPage: true, animations: 'disabled' }
      );
    });
  }
});
