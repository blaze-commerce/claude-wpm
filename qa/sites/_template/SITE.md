# Site: [SITE_NAME]

> **Last Updated:** [DATE]
> **Status:** Planned
> **Total Pages:** [COUNT]
> **Total Screenshots:** [COUNT × 4 browsers × 3 viewports]

---

## Environments

| Environment | URL | Status |
|-------------|-----|--------|
| **Live** | https://[DOMAIN] | Active |
| Staging 1 | https://staging1.[DOMAIN] | TBD |
| Staging 2 | https://staging2.[DOMAIN] | TBD |

---

## Page Inventory

### Static/Marketing Pages

| # | Page | Path | Notes |
|---|------|------|-------|
| 1 | Home | `/` | Homepage |
| 2 | About | `/about/` | |
| ... | ... | ... | ... |

### WooCommerce Core Pages

| # | Page | Path | Notes |
|---|------|------|-------|
| | Shop | `/shop/` | Product listing |
| | Cart | `/cart/` | Shopping cart |
| | Checkout | `/checkout/` | Checkout page |
| | My Account | `/my-account/` | Customer account |

### Product Pages

| # | Product | Path | Type |
|---|---------|------|------|
| | [Product Name] | `/product/[slug]/` | Simple/Variable |

---

## Test Matrix

### Screenshot Count

| Group | Pages | × Browsers | × Viewports | = Screenshots |
|-------|-------|------------|-------------|---------------|
| Static Pages | ? | 4 | 3 | ? |
| WooCommerce Pages | ? | 4 | 3 | ? |
| Product Pages | ? | 4 | 3 | ? |
| **Total** | **?** | - | - | **?** |

---

## Baseline History

| Date | Version | Action | Notes |
|------|---------|--------|-------|
| [DATE] | 1.0 | Initial baseline | First capture |

---

## Commands

```bash
# Run all tests for this site
npm test -- --grep @[SITE_TAG]

# Run only on Chrome
npm run test:chrome -- --grep @[SITE_TAG]

# Update baselines after intentional changes
npm run test:update-baseline -- --grep @[SITE_TAG]
```

---

## Notes

- [Add site-specific notes here]

---

*Document Location: `qa/sites/[SITE_NAME]/SITE.md`*
