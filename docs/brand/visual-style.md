# Visual style

> All hex values and font names below are **estimated from the inspiration mockups**. Confirm against source design files before locking these into CSS variables.

## Color palette

| Role | Approx hex | Notes |
|---|---|---|
| Primary green (buttons, accents, logo) | `#7A8B5C` | Muted sage / olive — the dominant brand color |
| Deep green (hover, headings accent) | `#5C6B43` | Slightly darker sage for hover states and secondary emphasis |
| Cream / warm white (page background) | `#F7F4ED` | Warm off-white, not pure white — keeps the page feeling soft |
| Charcoal (body text) | `#2E2E2A` | Near-black with a warm undertone, not pure `#000` |
| Soft gray (dividers, captions) | `#D8D4CB` | Used for thin rules and section separators |
| Light sage (section backgrounds) | `#F2F6F2` | Used for the CTA banner near the footer (value confirmed by practitioner) |

## Typography

**Headlines (display serif).** Looks like a transitional / old-style serif with moderate contrast and slight elegance — not a high-contrast Didone. Top candidates:
- **Cormorant Garamond** (most likely)
- EB Garamond
- Lora

Used for: hero headline, section titles, service card titles.

**Body & UI (humanist sans).** Clean, neutral, slightly humanist — not geometric. Top candidates:
- **Inter** (most likely)
- Source Sans 3
- Manrope

Used for: paragraph copy, navigation, buttons, footer.

**Eyebrow / tagline (tracked uppercase sans).** Same family as body, set in `text-transform: uppercase` with letter-spacing in the `0.15em–0.2em` range. Used for: section eyebrows ("MY APPROACH", "SERVICES", "YOU MIGHT BE FEELING"), the tagline under the logo, and footer link labels.

**Hierarchy cues from the mockup:**
- Hero headline is large (~56–64px desktop), serif, regular or medium weight, tight leading
- Section headlines are ~32–40px, same serif
- Body copy is ~16–17px, sans, regular, leading around 1.6
- Eyebrow labels are ~12–13px, tracked, sans medium

## Iconography

Simple **single-weight line icons** in the primary green, set inside thin circular outlines. All icons feel hand-drawn-adjacent rather than geometric.

Icons seen in the mockup:
- Leaf / sapling (Trauma Therapy)
- Branched leaf (Nature-Based Therapy)
- Stacked stones / cairn (Integrative Healing)
- Tangled scribble (Overwhelmed or anxious)
- Mountain peaks (Stuck in patterns)
- Single leaf (Disconnected from yourself)
- Swimmer / wave (Carrying something heavy)

When we add new icons, match this style: single stroke, ~1.5px weight, soft rounded line caps, contained in a thin circle.

## Imagery direction

**Photography style:** soft, naturally lit, atmospheric. Heavy on greens and warm whites. The two hero images are:
1. Misty evergreen forest viewed from above the canopy
2. Backlit green leaves on a thin branch, with a blurred river/forest behind

**Supporting imagery:** still-life objects with botanical elements — e.g. a small white ceramic vase with leafy stems on a neutral surface.

**Avoid:** stock-y "people in therapy" shots, harsh studio light, saturated colors, anything urban or clinical.

**Treatment:** images are typically used full-bleed within a section, often with one side of the section as a generous text column on cream background. Lots of negative space.

## Layout principles

- **Generous whitespace** — every section breathes; no dense blocks
- **Asymmetric splits** — text left / image right (or vice versa), rarely centered slabs
- **Thin rules and small leaf glyphs** as section dividers, never heavy borders
- **Soft corner radius** on buttons (~4–6px), not pill-shaped
- **Buttons are filled sage with white text** for primary, ghost/outline for secondary
