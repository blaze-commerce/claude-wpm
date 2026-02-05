---
title: QA Testing
description: Playwright E2E testing for WordPress sites.
---

Claude WPM includes a Playwright-based QA testing framework for end-to-end testing of WordPress sites.

## Overview

The QA framework runs **from your local MacBook** and tests **live sites via HTTPS**. Tests simulate real browser user interactions.

```
┌───────────────┐        HTTPS           ┌───────────────┐
│  Playwright   │ ─────────────────────▶ │  WordPress    │
│  + Node.js    │    Tests run like a    │  WooCommerce  │
│  qa/ folder   │    real browser user   │               │
└───────────────┘                        └───────────────┘
```

## Setup

```bash
# Clone the repo
git clone git@github.com:blaze-commerce/claude-wpm.git
cd claude-wpm/qa

# Install dependencies
npm install
npx playwright install    # Downloads browsers
```

## Running Tests

```bash
npm test                  # All tests, all browsers
npm run test:chrome       # Chrome only
npm run test:headed       # Watch tests visually
```

## Test Reports

After running tests, reports are generated in `qa/playwright-report/`.

To view the HTML report:
```bash
npx playwright show-report
```

## Test Structure

```
qa/
├── config/             # Playwright configuration
├── shared/             # Reusable test fixtures & utilities
├── sites/              # Per-site test configurations
│   ├── shinetrim.com/
│   └── _template/      # Copy for new sites
├── package.json        # Node.js dependencies
└── README.md           # QA-specific documentation
```

## Adding Tests for a New Site

1. Copy `qa/sites/_template/` to `qa/sites/your-domain.com/`
2. Update the configuration with site-specific details
3. Add site-specific test cases
4. Run tests: `npm test -- --project=your-domain.com`
