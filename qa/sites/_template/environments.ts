/**
 * Environment configuration for [SITE_NAME]
 *
 * INSTRUCTIONS:
 * 1. Replace [DOMAIN] with your actual domain
 * 2. Update staging URLs when available
 * 3. Set defaultEnvironment as needed
 */

export const environments = {
  live: {
    name: 'Production',
    baseURL: 'https://[DOMAIN]',
    description: 'Live production site',
  },
  staging1: {
    name: 'Staging 1',
    baseURL: 'https://staging1.[DOMAIN]',
    description: 'Primary staging environment',
  },
  staging2: {
    name: 'Staging 2',
    baseURL: 'https://staging2.[DOMAIN]',
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
