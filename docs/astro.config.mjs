// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://blaze-commerce.github.io',
  base: '/claude-wpm/',
  integrations: [
    starlight({
      title: 'Claude WPM',
      logo: {
        dark: './src/assets/logo-dark.svg',
        light: './src/assets/logo-light.svg',
        replacesTitle: true,
      },
      social: {
        github: 'https://github.com/blaze-commerce/claude-wpm',
      },
      sidebar: [
        {
          label: 'Getting Started',
          autogenerate: { directory: 'getting-started' },
        },
        {
          label: 'Sites',
          autogenerate: { directory: 'sites' },
        },
        {
          label: 'Guides',
          autogenerate: { directory: 'guides' },
        },
        {
          label: 'Reference',
          autogenerate: { directory: 'reference' },
        },
      ],
      customCss: ['./src/styles/custom.css'],
    }),
  ],
});
