import { Page } from '@playwright/test';

/**
 * Shared utility functions for QA tests
 */

/**
 * Wait for page to be loaded (DOM content loaded, not waiting for all network)
 */
export async function waitForPageLoad(page: Page, timeout = 30000): Promise<void> {
  // Use domcontentloaded instead of networkidle - some pages have resources that never stop loading
  await page.waitForLoadState('domcontentloaded', { timeout });
  // Give a moment for initial render
  await page.waitForTimeout(1000);
}

/**
 * Wait for WooCommerce AJAX loaders to disappear
 */
export async function waitForWooLoader(page: Page): Promise<void> {
  const loaders = ['.blockUI', '.loading', '.wc-block-components-spinner'];
  for (const loader of loaders) {
    const element = page.locator(loader);
    if (await element.count() > 0) {
      await element.waitFor({ state: 'hidden', timeout: 10000 }).catch(() => {});
    }
  }
}

/**
 * Scroll page to capture full height (for lazy-loaded content)
 */
export async function scrollFullPage(page: Page): Promise<void> {
  await page.evaluate(async () => {
    const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));
    const scrollHeight = document.body.scrollHeight;
    const viewportHeight = window.innerHeight;
    let currentPosition = 0;

    while (currentPosition < scrollHeight) {
      window.scrollTo(0, currentPosition);
      currentPosition += viewportHeight;
      await delay(100);
    }

    // Scroll back to top
    window.scrollTo(0, 0);
    await delay(500);
  });
}

/**
 * Hide cookie consent banners and popups for cleaner screenshots
 */
export async function hideCookieBanners(page: Page): Promise<void> {
  await page.evaluate(() => {
    const selectors = [
      // Common cookie consent selectors
      '.cookie-consent',
      '.cookie-banner',
      '.cookie-notice',
      '#cookie-notice',
      '#cookie-law-info-bar',
      '.cc-banner',
      '.cc-window',
      '[class*="cookie"]',
      '[class*="gdpr"]',
      '[id*="cookie"]',
      // Popup overlays
      '.modal-backdrop',
      '.popup-overlay',
    ];

    selectors.forEach(selector => {
      document.querySelectorAll(selector).forEach(el => {
        (el as HTMLElement).style.display = 'none';
      });
    });
  });
}

/**
 * Prepare page for screenshot (hide dynamic content)
 */
export async function prepareForScreenshot(page: Page): Promise<void> {
  // Wait for network to settle
  await waitForPageLoad(page);

  // Scroll to load lazy images
  await scrollFullPage(page);

  // Hide cookie banners
  await hideCookieBanners(page);

  // Wait a bit for any animations to settle
  await page.waitForTimeout(500);
}

/**
 * Generate screenshot name based on page and context
 */
export function getScreenshotName(pageName: string, browser: string, viewport: string): string {
  return `${pageName}-${browser}-${viewport}.png`;
}

/**
 * Sanitize URL path to filename
 */
export function pathToFilename(urlPath: string): string {
  return urlPath
    .replace(/^\//, '')
    .replace(/\/$/, '')
    .replace(/\//g, '-')
    .replace(/[^a-zA-Z0-9-]/g, '')
    || 'home';
}

/**
 * Add delay between actions (rate limiting)
 */
export async function throttle(page: Page, ms = 500): Promise<void> {
  await page.waitForTimeout(ms);
}
