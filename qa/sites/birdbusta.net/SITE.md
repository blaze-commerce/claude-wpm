# Site: birdbusta.net

> **Last Updated:** 2026-01-26
> **Status:** Active
> **Total Pages:** 15
> **Total Screenshots:** 180 (15 pages × 4 browsers × 3 viewports)

---

## Environments

| Environment | URL | Status |
|-------------|-----|--------|
| **Live** | https://birdbusta.net | Active |
| Staging 1 | TBD | Planned |
| Staging 2 | TBD | Planned |

---

## Page Inventory

### Static/Marketing Pages (7)

| # | Page | Path | Notes |
|---|------|------|-------|
| 1 | About | `/about/` | Company information |
| 2 | Commercial | `/commercial/` | Commercial solutions |
| 3 | Domestic | `/domestic/` | Domestic solutions |
| 4 | Retailers | `/retailers/` | Retailer information |
| 5 | Buy Online | `/buy-online/` | Online purchase info |
| 6 | Contact | `/contact/` | Contact form |
| 7 | Privacy Policy | `/privacy-policy/` | Legal page |

### WooCommerce Core Pages (2)

| # | Page | Path | Notes |
|---|------|------|-------|
| 8 | Shop | `/shop/` | Product listing/archive |
| 9 | My Account | `/my-account-2/` | Customer account page |

### Product Pages (6)

| # | Product | Path | Type |
|---|---------|------|------|
| 10 | 1 Metre Bird Busta | `/product/1-metre-bird-busta/` | Simple |
| 11 | Bird Busta | `/product/bird-busta/` | Simple |
| 12 | EzyFit Rail Mount | `/product/bird-busta-ezyfit-rail-mount/` | Simple |
| 13 | Replacement Parts Pack | `/product/bird-busta-replacement-parts-pack/` | Simple |
| 14 | Flags Red | `/product/flags-red/` | Simple |
| 15 | Sand Bag (Red or Blue) | `/product/sand-bag-red-or-blue/` | Variable |

---

## Test Matrix

### Browsers

| Browser | Engine | Status |
|---------|--------|--------|
| Chrome | Chromium | Active |
| Firefox | Gecko | Active |
| Safari | WebKit | Active |
| Edge | Chromium | Active |

### Viewports

| Viewport | Dimensions | Device |
|----------|------------|--------|
| Desktop | 1920 × 1080 | Standard monitor |
| Tablet | 768 × 1024 | iPad |
| Mobile | 375 × 667 | iPhone |

### Screenshot Count

| Group | Pages | × Browsers | × Viewports | = Screenshots |
|-------|-------|------------|-------------|---------------|
| Static Pages | 7 | 4 | 3 | 84 |
| WooCommerce Pages | 2 | 4 | 3 | 24 |
| Product Pages | 6 | 4 | 3 | 72 |
| **Total** | **15** | - | - | **180** |

---

## Baseline History

| Date | Version | Action | Notes |
|------|---------|--------|-------|
| 2026-01-26 | 1.0 | Initial baseline | First capture |

---

## Commands

```bash
# Run all tests for this site
npm test -- --grep @birdbusta

# Run only on Chrome
npm run test:chrome -- --grep @birdbusta

# Update baselines after intentional changes
npm run test:update-baseline -- --grep @birdbusta

# Run headed (watch tests execute)
npm run test:headed -- --grep @birdbusta
```

---

## Notes

- Site uses WooCommerce for e-commerce
- Products are primarily "Bird Busta" deterrent devices
- Contact page has a form (screenshot only, no submission)
- My Account page may show login form if not authenticated

---

*Document Location: `qa/sites/birdbusta.net/SITE.md`*
