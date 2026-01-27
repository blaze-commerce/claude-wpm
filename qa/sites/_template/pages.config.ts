/**
 * Page configuration for [SITE_NAME]
 *
 * INSTRUCTIONS:
 * 1. Add your static pages to staticPages array
 * 2. Update wooPages with your WooCommerce page paths
 * 3. Add product pages to productPages array
 */

export interface PageConfig {
  name: string;
  path: string;
  group: 'static' | 'woo' | 'product';
  description?: string;
}

/**
 * Static/Marketing Pages
 */
export const staticPages: PageConfig[] = [
  {
    name: 'Home',
    path: '/',
    group: 'static',
    description: 'Homepage',
  },
  {
    name: 'About',
    path: '/about/',
    group: 'static',
    description: 'About page',
  },
  // Add more static pages...
];

/**
 * WooCommerce Core Pages
 */
export const wooPages: PageConfig[] = [
  {
    name: 'Shop',
    path: '/shop/',
    group: 'woo',
    description: 'Product listing page',
  },
  {
    name: 'Cart',
    path: '/cart/',
    group: 'woo',
    description: 'Shopping cart',
  },
  {
    name: 'My Account',
    path: '/my-account/',
    group: 'woo',
    description: 'Customer account page',
  },
  // Add more WooCommerce pages...
];

/**
 * Product Pages
 */
export const productPages: PageConfig[] = [
  {
    name: 'Example Product',
    path: '/product/example-product/',
    group: 'product',
    description: 'Example product page',
  },
  // Add more product pages...
];

/**
 * All pages combined
 */
export const allPages: PageConfig[] = [
  ...staticPages,
  ...wooPages,
  ...productPages,
];

/**
 * Get pages by group
 */
export function getPagesByGroup(group: PageConfig['group']): PageConfig[] {
  return allPages.filter(page => page.group === group);
}

/**
 * Summary statistics
 */
export const pageSummary = {
  static: staticPages.length,
  woo: wooPages.length,
  product: productPages.length,
  total: allPages.length,
};
