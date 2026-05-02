# Site blueprint

Page structure derived from the inspiration mockup. This captures **layout and information architecture only** — all section labels, card titles, button labels, and body copy in the source mockup were placeholder and are not reproduced here. Real copy will be supplied by the practitioner.

## Header

- Left: logo lockup (mark + wordmark + tagline)
- Center / right: ~5 primary nav links
- Far right: primary CTA button (sage fill) — likely "Book a Consult" or similar
- Sticky on scroll? TBD — recommend yes, with a slight background blur once scrolled

## Section 1 — Hero

- Split layout: text column left (~45%), full-bleed image right (~55%)
- Text: large serif headline, thin divider with leaf glyph, sans subhead, primary CTA button
- Image: misty forest canopy

## Section 2 — About / Approach

- Reversed split (image right, text left in the mockup)
- Text: eyebrow label, serif headline, two short body paragraphs, secondary text link
- Image: backlit leaves on a branch

## Section 3 — Services

- Centered eyebrow + headline above
- Three-column card row — each card: circular line icon, title, ~2-line description, text link
- Number of services and their names are TBD with the practitioner

## Section 4 — Empathy beat ("you might be feeling…")

- Light section with a small still-life image on the far left (vase with branches)
- Centered: eyebrow, four-icon row with short labels, closing line of reassurance
- This section names the visitor's experience before asking them to act — keep the structure even if the specific feelings change

## Section 5 — CTA banner

- Light sage background band across full width
- Left: two-line headline + supporting line
- Right: primary CTA button
- Decorative leaf flourish in the top-right corner

## Footer (minimal)

Practitioner asked for a minimal footer. Keep it small and uncluttered:

- Logo
- Email
- Phone
- Psychology Today profile link
- **Required CA BBS disclosure block** — name, credentials, ASW number, supervisor name + LMFT number (see [identity.md](identity.md) for the exact required content)
- **Required US disclosures** — Privacy Policy and Good Faith Estimate links
- Copyright line: © {year} Release Wellness, LLC

The disclosures are non-negotiable (state + federal compliance) but they can be set in small, restrained type so they don't overwhelm the minimal feel she wants.

## Notes for build

- The mockup mixes a **single-page-feel landing layout** with multi-page nav links. Confirm with the practitioner whether nav scrolls to anchors or routes to separate pages before we commit to a routing approach. Likely answer: separate pages for About and Services (since she has dedicated content for both); home, contact, and resources may be anchors or pages depending on depth.
- All "Book a Consult" / "Schedule a Consultation" CTAs point to her **SimplePractice** booking URL (confirmed). We'll plug in the exact URL when we wire them up.
- **Practitioner is licensed (registered) in California only** — the `ca` in `releasewellnessca.com` refers to California. Good Faith Estimate (US federal) and CA BBS supervision disclosure both apply.
