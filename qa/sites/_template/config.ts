/**
 * Site configuration for [SITE_NAME]
 *
 * INSTRUCTIONS:
 * 1. Update siteName and siteTag
 * 2. Import your pages from pages.config.ts
 */

import { getEnvironment, Environment } from './environments';
import { allPages, staticPages, wooPages, productPages, pageSummary } from './pages.config';

export interface SiteConfig {
  siteName: string;
  siteTag: string;
  baseURL: string;
  environment: string;
  pages: typeof allPages;
  groups: {
    static: typeof staticPages;
    woo: typeof wooPages;
    product: typeof productPages;
  };
  summary: typeof pageSummary;
}

/**
 * Get full site configuration for a given environment
 */
export function getSiteConfig(env?: Environment): SiteConfig {
  const environment = getEnvironment(env);

  return {
    siteName: '[SITE_NAME]',      // TODO: Update this
    siteTag: '@[SITE_TAG]',        // TODO: Update this (used for test filtering)
    baseURL: environment.baseURL,
    environment: environment.name,
    pages: allPages,
    groups: {
      static: staticPages,
      woo: wooPages,
      product: productPages,
    },
    summary: pageSummary,
  };
}

/**
 * Default export for convenience
 */
export default getSiteConfig();
