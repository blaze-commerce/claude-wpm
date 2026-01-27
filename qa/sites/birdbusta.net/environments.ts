/**
 * Environment configuration for birdbusta.net
 *
 * Defines all available environments (live, staging, etc.)
 */

export const environments = {
  live: {
    name: 'Production',
    baseURL: 'https://birdbusta.net',
    description: 'Live production site',
  },
  staging1: {
    name: 'Staging 1',
    baseURL: 'https://staging1.birdbusta.net', // TODO: Update with actual URL
    description: 'Primary staging environment',
  },
  staging2: {
    name: 'Staging 2',
    baseURL: 'https://staging2.birdbusta.net', // TODO: Update with actual URL
    description: 'Secondary staging environment',
  },
} as const;

export type Environment = keyof typeof environments;
export const defaultEnvironment: Environment = 'live';

/**
 * Get environment configuration
 */
export function getEnvironment(env?: string): typeof environments[Environment] {
  const envKey = (env || process.env.QA_ENVIRONMENT || defaultEnvironment) as Environment;

  if (!(envKey in environments)) {
    throw new Error(`Unknown environment: ${envKey}. Available: ${Object.keys(environments).join(', ')}`);
  }

  return environments[envKey];
}
