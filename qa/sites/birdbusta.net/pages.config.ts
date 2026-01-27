/**
 * Page configuration for birdbusta.net
 *
 * Defines all pages to be tested with their paths and groupings.
 * This serves as both configuration and documentation.
 */

export interface PageConfig {
  name: string;
  path: string;
  group: 'static' | 'woo' | 'product';
  description?: string;
}

/**
 * Static/Marketing Pages
 * Standard WordPress pages with marketing content
 */
export const staticPages: PageConfig[] = [
  {
    name: 'About',
    path: '/about/',
    group: 'static',
    description: 'Company information page',
  },
  {
    name: 'Commercial',
    path: '/commercial/',
    group: 'static',
    description: 'Commercial solutions page',
  },
  {
    name: 'Domestic',
    path: '/domestic/',
    group: 'static',
    description: 'Domestic solutions page',
  },
  {
    name: 'Retailers',
    path: '/retailers/',
    group: 'static',
    description: 'Retailer information page',
  },
  {
    name: 'Buy Online',
    path: '/buy-online/',
    group: 'static',
    description: 'Online purchase information',
  },
  {
    name: 'Contact',
    path: '/contact/',
    group: 'static',
    description: 'Contact form page',
  },
  {
    name: 'Privacy Policy',
    path: '/privacy-policy/',
    group: 'static',
    description: 'Privacy policy legal page',
  },
];

/**
 * WooCommerce Core Pages
 * Essential WooCommerce pages
 */
export const wooPages: PageConfig[] = [
  {
    name: 'Shop',
    path: '/shop/',
    group: 'woo',
    description: 'Main product listing/archive page',
  },
  {
    name: 'My Account',
    path: '/my-account-2/',
    group: 'woo',
    description: 'Customer account dashboard/login',
  },
];

/**
 * Product Pages
 * Individual product pages
 */
export const productPages: PageConfig[] = [
  {
    name: '1 Metre Bird Busta',
    path: '/product/1-metre-bird-busta/',
    group: 'product',
    description: '1 metre version of Bird Busta',
  },
  {
    name: 'Bird Busta',
    path: '/product/bird-busta/',
    group: 'product',
    description: 'Main Bird Busta product',
  },
  {
    name: 'EzyFit Rail Mount',
    path: '/product/bird-busta-ezyfit-rail-mount/',
    group: 'product',
    description: 'Rail mount accessory',
  },
  {
    name: 'Replacement Parts Pack',
    path: '/product/bird-busta-replacement-parts-pack/',
    group: 'product',
    description: 'Replacement parts bundle',
  },
  {
    name: 'Flags Red',
    path: '/product/flags-red/',
    group: 'product',
    description: 'Red flags accessory',
  },
  {
    name: 'Sand Bag',
    path: '/product/sand-bag-red-or-blue/',
    group: 'product',
    description: 'Sand bag (red or blue variant)',
  },
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
