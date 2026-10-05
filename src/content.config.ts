// Editable site content. Each page's copy lives in one YAML file under
// src/content/pages/, which Tanya edits through the CMS at /admin
// (public/admin/config.yml mirrors these schemas — keep the two in sync).
//
// The schemas are the safety net for edits that go straight to live: a
// missing or malformed field fails the build, and Cloudflare keeps serving
// the last good deploy.
//
// Deliberately NOT here (locked in code): layout, button labels, nav, the BBS
// credentials/supervision disclosure (src/data/site.ts), BOOKING_URL, and the
// legal pages.
import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const text = z.string().trim().min(1);

// Images are stored as repo paths ("/src/assets/…") and resolved to optimized
// assets by src/lib/images.ts.
const imagePath = z
  .string()
  .regex(/^\/src\/assets\/.+\.(jpe?g|png|webp|avif)$/i, 'Image must be a JPG, PNG, WebP or AVIF under /src/assets/');

const seo = z.object({
  title: text,
  description: text,
});

const section = z.object({
  heading: text,
  body: text,
});

const page = (name: string) => glob({ pattern: `${name}.yaml`, base: './src/content/pages' });

const home = defineCollection({
  loader: page('home'),
  schema: z.object({
    seo,
    hero: z.object({ heading: text, lede: text, image: imagePath }),
    welcome: z.object({ heading: text, body: text, image: imagePath }),
    services_heading: text,
    feelings: z.object({ items: z.array(text).min(1), closing: text }),
    about_preview: z.object({ heading: text, body: text, image: imagePath, image_alt: text }),
    cta: section,
  }),
});

const about = defineCollection({
  loader: page('about'),
  schema: z.object({
    seo,
    heading: text,
    portrait: imagePath,
    portrait_alt: text,
    lede: text,
    sections: z.array(section).min(1),
    closing: text,
  }),
});

const services = defineCollection({
  loader: page('services'),
  schema: z.object({
    seo,
    heading: text,
    intro: text,
    help_with: z.object({ heading: text, items: z.array(text).min(1) }),
    therapy_is: z.object({ heading: text, items: z.array(text).min(1) }),
    modalities_heading: text,
    modalities: z
      .array(z.object({ title: text, home_summary: text, description: text }))
      .min(1),
    cta: section,
  }),
});

const fees = defineCollection({
  loader: page('fees'),
  schema: z.object({
    seo,
    heading: text,
    intro: text,
    fee_list: z.array(z.object({ label: text, amount: text })).min(1),
    fee_note: text,
    policies: z.array(section),
    cta: section,
  }),
});

const contact = defineCollection({
  loader: page('contact'),
  schema: z.object({
    seo,
    heading: text,
    intro: text,
  }),
});

const settings = defineCollection({
  loader: page('settings'),
  schema: z.object({
    email: z.string().trim().email(),
    phone: z
      .string()
      .trim()
      .refine((v) => /^1?\d{10}$/.test(v.replace(/\D/g, '')), 'Phone must be a 10-digit US number'),
    address_line1: text,
    address_line2: text,
    psychology_today_url: z.string().url().optional(),
    instagram_url: z.string().url().optional(),
    facebook_url: z.string().url().optional(),
  }),
});

export const collections = { home, about, services, fees, contact, settings };
