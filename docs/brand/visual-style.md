# Visual style

> **Color palette is locked** as of 2026-05-12 to Tanya's "Mountain Macramé" color board ([docs/brand/assets/inspiration/color-board.png](assets/inspiration/color-board.png)). Font names below remain estimates from the inspiration mockups — confirm against source design files before locking.

## Color palette

Source of truth: [Mountain Macramé color board](assets/inspiration/color-board.png). All values mapped 1:1 to CSS variables in [src/styles/tokens.css](../../src/styles/tokens.css).

### In active use

| Role | Token | Hex | Notes |
|---|---|---|---|
| Sage (icons, ghost-button border, soft accents) | `--color-sage` | `#7FA08F` | Board "Sage" — soft natural green |
| Forest (primary buttons, headings accent, links) | `--color-sage-deep` | `#3C5A4A` | Board "Forest" — deep grounding green |
| Light sage (CTA banner, soft section bg) | `--color-sage-light` | `#EFF3F0` | Derived tint of board Sage |
| Cream (page background) | `--color-cream` | `#F7F4ED` | Warm off-white, not pure white |
| Charcoal (body text) | `--color-charcoal` | `#2E2E2A` | Near-black with warm undertone |
| Soft gray (dividers, captions) | `--color-rule` | `#D8D4CB` | Thin rules, section separators |

### Defined for future use

These come from the board but aren't applied yet. Reach for them when adding secondary UI, illustrations, hover states, or alternate section backgrounds.

| Role | Token | Hex | Board name |
|---|---|---|---|
| Secondary — soft teal mid-tone | `--color-misty-teal` | `#A6BFB7` | Misty Teal |
| Secondary — cool muted blue | `--color-mountain-blue` | `#6A6477` | Mountain Blue |
| Accent — rich depth, type contrast | `--color-deep-indigo` | `#2F344A` | Deep Indigo |
| Warm neutral — cards, dividers | `--color-sand` | `#DCC9A6` | Sand |
| Warm neutral, lighter | `--color-oatmeal` | `#DDCBA8` | Oatmeal |
| Balanced gray | `--color-stone` | `#8E8E84` | Stone |
| Natural accent — wood elements | `--color-warm-wood` | `#A2823E` | Warm Wood |
| Alt clean background | `--color-ivory` | `#F7F1E3` | Ivory |

### How to use the palette (from board)

- **Primary** (Forest, Sage) — backgrounds, headings, key icons
- **Secondary** (Misty Teal, Mountain Blue) — accents and highlights
- **Accent** (Deep Indigo) — contrast, type, important details
- **Neutrals** (Sand, Oatmeal, Stone) — backgrounds, cards, dividers
- **Natural accent** (Warm Wood) — wood elements, frames
- **Background** (Ivory) — clean, airy, light

### Contrast notes

- White text on `--color-sage` (`#7FA08F`) fails WCAG AA (~2.9:1). Primary buttons therefore use `--color-sage-deep` (Forest, ~9.4:1).
- Ghost-button hover fills with Sage and switches text to charcoal (`--color-charcoal`, ~5.5:1) rather than white.

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
