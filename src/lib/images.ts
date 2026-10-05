import type { ImageMetadata } from 'astro';

// Every image under src/assets/, keyed by repo path ("/src/assets/hero.webp").
// Content YAML stores images as these paths (the CMS uploads straight into
// src/assets/, see public/admin/config.yml), so they go through Astro's image
// optimizer. A path that doesn't exist fails the build.
const images = import.meta.glob<{ default: ImageMetadata }>(
  '/src/assets/**/*.{jpg,jpeg,png,webp,avif,JPG,JPEG,PNG,WEBP,AVIF}',
  { eager: true },
);

export function resolveImage(path: string): ImageMetadata {
  const image = images[path];
  if (!image) {
    throw new Error(`Image not found: "${path}". Content images must live under /src/assets/.`);
  }
  return image.default;
}
