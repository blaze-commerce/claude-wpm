/**
 * Screenshot Tests for birdbusta.net
 *
 * Visual regression testing across all pages, browsers, and viewports.
 * First run establishes baseline, subsequent runs compare against it.
 *
 * Total: 15 pages × 4 browsers × 3 viewports = 180 screenshots
 */

import { test, expect } from '@playwright/test';
import { getSiteConfig } from '../config';
import { staticPages, wooPages, productPages } from '../pages.config';
import { prepareForScreenshot, pathToFilename } from '../../../shared/utils/helpers';

const config = getSiteConfig();

// ============================================================================
// STATIC PAGES (7 pages)
// ============================================================================

test.describe(`Static Pages @birdbusta @static`, () => {
  for (const page of staticPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      // Navigate to page (use domcontentloaded for faster, more reliable loading)
      await browserPage.goto(`${config.baseURL}${page.path}`, { waitUntil: 'domcontentloaded' });

      // Prepare for screenshot (wait for load, scroll for lazy images, hide popups)
      await prepareForScreenshot(browserPage);

      // Capture full-page screenshot and compare to baseline
      await expect(browserPage).toHaveScreenshot(
        `static/${pathToFilename(page.path)}.png`,
        {
          fullPage: true,
          animations: 'disabled',
        }
      );
    });
  }
});

// ============================================================================
// WOOCOMMERCE CORE PAGES (2 pages)
// ============================================================================

test.describe(`WooCommerce Pages @birdbusta @woo`, () => {
  for (const page of wooPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      // Navigate to page (use domcontentloaded for faster, more reliable loading)
      await browserPage.goto(`${config.baseURL}${page.path}`, { waitUntil: 'domcontentloaded' });

      // Prepare for screenshot
      await prepareForScreenshot(browserPage);

      // Capture full-page screenshot and compare to baseline
      await expect(browserPage).toHaveScreenshot(
        `woo/${pathToFilename(page.path)}.png`,
        {
          fullPage: true,
          animations: 'disabled',
        }
      );
    });
  }
});

// ============================================================================
// PRODUCT PAGES (6 pages)
// ============================================================================

test.describe(`Product Pages @birdbusta @product`, () => {
  for (const page of productPages) {
    test(`${page.name} - full page screenshot`, async ({ page: browserPage }) => {
      // Navigate to page (use domcontentloaded for faster, more reliable loading)
      await browserPage.goto(`${config.baseURL}${page.path}`, { waitUntil: 'domcontentloaded' });

      // Prepare for screenshot
      await prepareForScreenshot(browserPage);

      // Capture full-page screenshot and compare to baseline
      await expect(browserPage).toHaveScreenshot(
        `products/${pathToFilename(page.path)}.png`,
        {
          fullPage: true,
          animations: 'disabled',
        }
      );
    });
  }
});
