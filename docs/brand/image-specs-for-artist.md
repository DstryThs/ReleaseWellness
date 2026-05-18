# Image specs for the artist

Hand this doc to whoever is producing the logo and photography for Release Wellness. It covers file formats, sizes, color, and the variants the website needs. Brand direction (colors, type, mood) lives in [identity.md](identity.md) and [visual-style.md](visual-style.md) — share those alongside this spec.

---

## 1. Logo

### Source files (deliverables)

We need **vector source files** as the master. Raster (PNG) exports are derived from those — the artist should not deliver only PNGs.

| Format | Purpose | Notes |
|---|---|---|
| **SVG** | Master file for web use | One per variant below. Optimized (no embedded raster, no editor metadata). |
| **AI** or **PDF** | Editable source | Original vector file with live type and layers preserved, in case we ever need to adjust. |
| **PNG** | Raster fallbacks | Transparent background. See sizes below. |

### Variants needed

Each variant should be delivered as its own SVG + PNG set:

1. **Vertical lockup** — mark on top, "Release Wellness" wordmark below, thin divider with leaf glyph, tagline "USING ELEMENTS OF NATURE TO NURTURE" beneath. Used on the homepage hero, business cards, signage.
2. **Horizontal lockup** — small mark on the left, wordmark stacked with tagline on the right. Used in the site header, footer, social profile banner.
3. **Mark only** — the circular tree-ring emblem with no type. Used for the favicon, social avatar, and small UI moments.
4. **Wordmark only** — "Release Wellness" set in the display serif, no mark. Used occasionally where the mark is redundant.

### Color treatments

For each of the 4 variants above, deliver these color versions:

- **Full color** — primary sage/forest palette (see hex values below)
- **Single-color forest** — `#3C5A4A` (for use on cream/white backgrounds)
- **Single-color black** — `#000000` (for print, fax, single-color reproduction)
- **Reverse (cream on dark)** — `#F7F4ED` mark and type on a transparent background, for use on dark photo overlays or the forest-green color

So the full delivery is **4 variants × 4 color treatments = 16 SVG files + 16 PNG files**, plus the editable AI/PDF master.

### Brand colors (for reference)

| Role | Hex |
|---|---|
| Sage (primary mark color) | `#7FA08F` |
| Forest (deep, type and dark variant) | `#3C5A4A` |
| Cream (background, reverse type) | `#F7F4ED` |
| Charcoal (body text) | `#2E2E2A` |

Full palette: [visual-style.md](visual-style.md#color-palette).

### PNG export sizes

Transparent background, sRGB color space. Export each variant + color combo at:

- **Horizontal lockup**: 600px wide, 1200px wide, 2400px wide
- **Vertical lockup**: 600px wide, 1200px wide, 2400px wide
- **Mark only**: 256×256, 512×512, 1024×1024 (square)
- **Wordmark only**: 600px wide, 1200px wide, 2400px wide

### Favicon

Deliver a **simplified version of the mark** optimized for tiny sizes (16×16 and 32×32 in particular). At those sizes fine wood-grain detail will mud out — the artist should manually simplify the interior so it still reads as a tree on a tree-ring slice. Provide:

- `favicon.svg` (the simplified mark as SVG)
- `favicon-512.png` (512×512 raster, for tools that don't support SVG)

### Clearspace & minimum size

The artist should document, in a one-page PDF style guide:

- **Minimum clearspace** around the lockup (typically the height of the wordmark "R" on all sides)
- **Minimum display size** for each lockup (horizontal lockup typically can't go below ~120px wide before it stops reading)

### Typography in the logo

If "Release Wellness" is set in a licensed typeface, **name the typeface and weight in the delivery notes** so we can match it elsewhere on the site. Current best guess from the mockup is Cormorant Garamond — confirm or replace.

---

## 2. Photography

### Master files (deliverables)

For each photograph:

| Format | Purpose |
|---|---|
| **Original RAW / TIFF** | Untouched original, color space ProPhoto or Adobe RGB. Keep on file in case we need to re-edit. |
| **High-res JPG** | Color-corrected, sRGB, 100% quality, full sensor resolution. The working file we'll edit down from. |
| **Web JPG** (we can produce from the high-res) | 2400px on the long edge, 80% quality, sRGB. |

The artist's job is the first two. The web export step happens during site build — they don't need to deliver compressed web files, but the master JPG must be **sRGB color space** (not Adobe RGB or ProPhoto), or colors will shift in the browser.

### Resolution & aspect ratios

| Use | Aspect ratio | Minimum long edge |
|---|---|---|
| Homepage hero | 4:5 (portrait) | 3000px |
| Section feature images (e.g. "approach") | 4:5 or 1:1 | 2400px |
| Practitioner portrait (Tanya) | 4:5 (portrait) | 2400px |
| Service detail / supporting | 3:2 or 4:5 | 2000px |
| Full-bleed background (if used) | 16:9 (landscape) | 3000px |

Shooting wider than the final crop is fine — actually preferred, so we have headroom to recompose. But **don't crop tighter than 4:5 portrait for hero candidates** — we need vertical headroom and bottom space for the gradient overlay.

### Style direction

Full direction is in [visual-style.md § Imagery direction](visual-style.md#imagery-direction). Headline version:

- **Mood:** soft, naturally lit, atmospheric, heavy on greens and warm whites
- **Subjects:** nature, modality-evocative (water, stones, leaves, hands at work), still-lifes with botanical elements
- **Avoid:** stock-y "people in therapy" shots, harsh studio light, saturated colors, urban or clinical settings
- **People in frame:** keep person-light. The only identifiable face on the site should be Tanya's actual portrait — see imagery memo at [docs/brand/](.) for context.

### Practitioner portrait (Tanya) — specifics

This is the one shot where a person *is* the subject:

- Natural light, outdoors or near a large window, not studio strobe
- Soft, warm color grading consistent with the rest of the photography
- Mid-distance: head-and-shoulders to waist-up, never tightly cropped headshot
- Eyes can meet camera or look off — both work, but deliver options
- Wardrobe in the brand palette (sage, cream, warm neutrals, soft wood tones)
- Background: natural setting (forest, beach, soft greenery) preferred over interiors

Deliver **at least 3 final options** so we can pick the one that pairs best with the about-page copy.

### File naming

Lowercase, hyphenated, descriptive. Examples:

```
hero-misty-canopy.jpg
hero-backlit-leaves.jpg
approach-river-stones.jpg
portrait-tanya-forest.jpg
portrait-tanya-window.jpg
still-life-vase-leaves.jpg
```

No spaces, no underscores, no version numbers like `final-v2-USE-THIS.jpg`.

### Rights & usage

The artist should confirm in writing:

- We have **full commercial usage rights** for web, print, and social
- No model release issues (only Tanya appears as an identifiable person)
- No third-party stock or AI-generated elements composited in without disclosure

---

## 3. Delivery checklist

A clean handoff looks like:

```
release-wellness-brand-delivery/
├── logo/
│   ├── source/
│   │   └── release-wellness-master.ai   (or .pdf)
│   ├── svg/
│   │   ├── release-wellness-lockup-vertical-color.svg
│   │   ├── release-wellness-lockup-vertical-forest.svg
│   │   ├── release-wellness-lockup-vertical-black.svg
│   │   ├── release-wellness-lockup-vertical-reverse.svg
│   │   ├── release-wellness-lockup-horizontal-color.svg
│   │   ├── ... (same 4 colors for horizontal, mark, wordmark)
│   │   ├── release-wellness-mark-color.svg
│   │   ├── ... etc
│   │   └── favicon.svg
│   ├── png/
│   │   └── (PNG exports at the sizes listed above)
│   └── style-guide.pdf   (clearspace, min size, typeface name)
└── photography/
    ├── source/
    │   └── (RAW + high-res sRGB JPG masters)
    └── selects/
        └── (the artist's recommended final picks, named per convention)
```

Send that whole folder over to us and we'll do the web optimization, srcset generation, and integration on our end.

---

## 4. If using AI image tools

This section applies if any part of the work is being produced with generative AI (Midjourney, DALL-E, Stable Diffusion, Adobe Firefly, Recraft, etc.). Read this **before** starting — it changes what's deliverable and what's off-limits.

### Logo: not a good fit for AI

The logo deliverables in § 1 assume a human designer working in vector software. AI tools cannot reasonably produce that package:

- **No true vector output.** AI generators produce raster pixels. SVG-capable tools (Recraft, Illustrator generative features) produce traced approximations that aren't clean enough for production use — they break at small sizes, the curves are noisy, and the file isn't editable in a way a designer can refine.
- **Text rendering is unreliable.** Wordmarks ("Release Wellness") often come out misspelled, with wrong letter spacing, or in a typeface we can't identify or license.
- **Consistency across variants is hard.** Producing the *same* mark in vertical lockup, horizontal lockup, mark-only, and 4 color treatments — pixel-identical, just recomposed — is exactly what AI tools are bad at.
- **Trademark defensibility is weaker.** Fully AI-generated marks have a murkier ownership and originality story, which matters if the practice ever needs to enforce its brand.

**Recommended workflow if AI is in the mix:** use AI to *ideate* logo directions (mood, composition, the tree-ring concept), then hand the chosen direction to a human designer to redraw as proper vector files. The redraw step is where the deliverable package in § 1 actually gets produced.

### Photography: Tanya's portrait must be a real photo

This is not negotiable. Tanya is a registered associate clinician under California BBS rules — the site is advertising her real credentials and her real supervisor. A synthetic or AI-modified portrait of her would misrepresent a regulated practitioner. That's a credibility and potential compliance issue, separate from any ethics concern.

**Real camera, real Tanya, real lighting.** AI touch-ups for skin smoothing or background cleanup are fine in moderation; AI generation or face-swapping is not.

### Photography: AI is workable for the rest, with cautions

For the modality / nature / still-life shots (hero candidates, "approach" section imagery, supporting photography), AI tools can produce strong results that fit the brand direction. Cautions:

- **Output license.** Confirm in writing that the tool's terms of service grant **full commercial usage rights** at the subscription tier being used. Midjourney, DALL-E, Firefly, and Recraft all have different rules, and some restrict commercial use to higher-priced plans.
- **Color space.** Outputs are usually sRGB, but verify — and check that the brand sage/forest tones (`#7FA08F`, `#3C5A4A`) actually land in palette rather than drifting toward saturated emerald or muddy olive. Color-grade in post if needed.
- **Resolution.** Confirm the tool can produce the long-edge sizes in § 2 (3000px for hero) natively, not through upscaling. Upscaled AI images often have soft, plasticky detail that betrays the source.
- **Style consistency.** Use the same prompt scaffold, seed, or a reference image across all generations for the site, or you'll get a grab-bag of images that don't feel like one practice. Pick a "look" and lock it.
- **Watch for anatomical and physical errors.** Hands, faces, plant structure, and reflections still go wrong often. The "person-light" direction in § 2 helps sidestep the worst of this, but inspect every selected image at full resolution — particularly any half-visible hands in still-lifes, leaf and branch structure that doesn't follow real botany, and water/reflection logic.
- **Iterate hard, then curate.** Generate 20+ candidates for every slot and throw away most. The hit rate is low; the keepers are the point.
- **No copyrighted-looking outputs.** Reject anything that closely mimics a recognizable photographer's style, a specific stock image, or a known brand's photography.

### Disclosure

If AI-generated imagery is used on the site, add a short disclosure — a single line in the privacy page or footer such as:

> *Some imagery on this site is AI-generated or AI-assisted. The portrait of the practitioner is a real photograph.*

Some clients care about this; some don't. Being upfront in advance beats having to explain after the fact, and the second sentence is the one that matters — it preserves the credibility of Tanya's identifiable portrait.

### Updated delivery from an AI workflow

If AI is producing the photography, the § 3 checklist changes:

- `photography/source/` won't contain RAW files — instead, save the **original full-resolution output from the AI tool** (not a re-export or screenshot) and a **text file with the prompt, seed, tool, and model version** used. That metadata is the equivalent of the RAW: it's what lets us regenerate or refine later.
- Color-correct in Lightroom / Photoshop / Affinity after generation, and save those edited versions as the sRGB JPG masters described in § 2.
