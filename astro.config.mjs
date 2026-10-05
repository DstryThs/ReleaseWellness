import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://releasewellnessca.com',
  output: 'static',
  integrations: [
    // /admin/ is the CMS editor (public/admin/) — keep it out of search.
    sitemap({ filter: (page) => !page.includes('/admin') }),
  ],
});
