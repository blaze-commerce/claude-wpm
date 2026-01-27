import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

/**
 * Playwright Configuration for Blaze QA
 *
 * Supports:
 * - 4 browsers: Chrome, Firefox, Safari, Edge
 * - 3 viewports: Desktop (1920x1080), Tablet (768x1024), Mobile (375x667)
 * - Visual regression with baseline screenshots
 */

// Viewport definitions
const viewports = {
  desktop: { width: 1920, height: 1080 },
  tablet: { width: 768, height: 1024 },
  mobile: { width: 375, height: 667 },
};

export default defineConfig({
  // Test directory - looks in sites folder, excludes _template
  testDir: '../sites',
  testMatch: '**/*.spec.ts',
  testIgnore: ['**/sites/_template/**'],

  // Parallel execution settings
  fullyParallel: true,
  workers: process.env.CI ? 2 : 4,

  // Retry failed tests
  retries: process.env.CI ? 2 : 1,

  // Reporter configuration
  reporter: [
    ['html', { outputFolder: '../reports/html', open: 'never' }],
    ['json', { outputFile: '../reports/results.json' }],
    ['list'],
  ],

  // Global test settings
  use: {
    // Tracing and debugging
    trace: 'on-first-retry',
    screenshot: 'on',  // Capture screenshots for ALL tests (pass/fail) for documentation
    video: 'retain-on-failure',

    // Timeouts
    actionTimeout: 15000,
    navigationTimeout: 60000,

    // Request throttling to avoid rate limiting
    extraHTTPHeaders: {
      'Accept-Language': 'en-US,en;q=0.9',
    },
  },

  // Global timeout
  timeout: 60000,

  // Screenshot comparison settings
  expect: {
    toHaveScreenshot: {
      // Allow 0.2% pixel difference (for anti-aliasing, etc.)
      maxDiffPixelRatio: 0.002,
      // Animation handling
      animations: 'disabled',
      // Timeout for screenshot capture (default is 5000ms)
      timeout: 15000,
    },
  },

  // Browser projects - 4 browsers × 3 viewports = 12 configurations
  projects: [
    // ============ CHROME ============
    {
      name: 'chrome-desktop',
      use: {
        ...devices['Desktop Chrome'],
        viewport: viewports.desktop,
      },
    },
    {
      name: 'chrome-tablet',
      use: {
        ...devices['Desktop Chrome'],
        viewport: viewports.tablet,
      },
    },
    {
      name: 'chrome-mobile',
      use: {
        ...devices['iPhone 13'],
      },
    },

    // ============ FIREFOX ============
    // Note: Firefox-mobile removed - Playwright's Firefox doesn't support true mobile emulation
    {
      name: 'firefox-desktop',
      use: {
        ...devices['Desktop Firefox'],
        viewport: viewports.desktop,
      },
    },
    {
      name: 'firefox-tablet',
      use: {
        ...devices['Desktop Firefox'],
        viewport: viewports.tablet,
      },
    },

    // ============ SAFARI (WebKit) ============
    {
      name: 'safari-desktop',
      use: {
        ...devices['Desktop Safari'],
        viewport: viewports.desktop,
      },
    },
    {
      name: 'safari-tablet',
      use: {
        ...devices['iPad Pro 11'],
      },
    },
    {
      name: 'safari-mobile',
      use: {
        ...devices['iPhone 13'],
      },
    },

    // ============ EDGE ============
    // Note: Edge requires Microsoft Edge to be installed on macOS
    // Install via: brew install --cask microsoft-edge
    {
      name: 'edge-desktop',
      use: {
        ...devices['Desktop Edge'],
        channel: 'msedge',
        viewport: viewports.desktop,
      },
    },
    {
      name: 'edge-tablet',
      use: {
        ...devices['Desktop Edge'],
        channel: 'msedge',
        viewport: viewports.tablet,
      },
    },
    {
      name: 'edge-mobile',
      use: {
        ...devices['Desktop Edge'],
        channel: 'msedge',
        viewport: viewports.mobile,
        isMobile: true,
      },
    },
  ],
});
