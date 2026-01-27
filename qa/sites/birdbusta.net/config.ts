/**
 * Site configuration for birdbusta.net
 *
 * Central configuration that combines environment, pages, and any site-specific settings.
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
    siteName: 'birdbusta.net',
    siteTag: '@birdbusta',
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
