# Brand asset files

Source files for the brand. The markdown docs in the parent folder describe and reference them.

## Currently here

- `inspiration/Website-Concept-Inspiration.jpg` — full homepage mockup. **Body copy in this image is placeholder; do not transcribe.** Use it for layout, color, type, and imagery direction only.
- `logo/Brand-Assets.PNG` — brand asset sheet showing logo lockup variants and application mockups (business card, signage, social).

## Suggested layout for future additions

```
assets/
├── logo/
│   ├── release-wellness-lockup-vertical.svg     # full vertical lockup
│   ├── release-wellness-lockup-horizontal.svg   # header/footer lockup
│   ├── release-wellness-mark.svg                # circle mark only (favicon source)
│   ├── release-wellness-wordmark.svg            # wordmark only
│   └── png-exports/                             # PNG fallbacks at common sizes
├── photography/
│   └── (hero forest, leaves, still-life, etc. — original resolution)
├── inspiration/
│   ├── homepage-mockup.png                      # the full website mockup Mike shared
│   └── brand-asset-sheet.png                    # the logo + mockup sheet Mike shared
└── icons/
    └── (line icons used in services + "you might be feeling" sections)
```

## Naming

Lowercase, hyphenated, no spaces. Include the variant in the filename (`-vertical`, `-horizontal`, `-mark`).

## Formats

- **SVG** preferred for logo and icons (scalable, small, easy to recolor)
- **PNG** for raster exports of the logo (transparent background, at least 2x the largest expected display size)
- **JPG** for photography (web-optimized, ~80% quality, max 2400px on the long edge)

Once files are in place, update the markdown docs to reference them by relative path.
