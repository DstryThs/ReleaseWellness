# Build plan — Release Wellness website

> **Approved v1, 2026-05-01.** All eight open questions resolved (see [Decisions](#decisions-resolved-2026-05-01)). Ready to scaffold Phase 1. This remains a living doc — we'll update it as Phase 2 content arrives and decisions evolve.

## Goal

Ship a fast, accessible, beautifully-branded marketing/brochure site for a single-practitioner therapy practice. No PHI, no auth, no CMS. Deploy on Cloudflare Pages free tier. Make it easy for the practitioner (or a future maintainer) to update copy and images without a developer.

## Tech stack

**Recommendation: [Astro](https://astro.build)**

Reasoning:
- **Static-first.** Astro renders to plain HTML by default and ships zero JavaScript unless a component opts in. Ideal for a brochure site where the bulk of the page is text + images.
- **Islands of interactivity.** The parallax background motion and ambient video need a little JS — Astro's "islands" model lets us add interactivity to one component without bloating the rest of the page.
- **MDX content collections.** Copy can live as Markdown files (one per service, the About page, etc.) with a typed schema. This makes it trivial to edit copy later without touching layout code, and gives us validation that all required fields exist.
- **First-class Cloudflare Pages support** — official adapter, well-documented integration.
- **Built-in image optimization.** Astro's `<Image>` component generates WebP/AVIF, srcsets, and lazy-loading. Important for a media-heavy site.

**Alternatives considered:**
- **Plain HTML/CSS + Vite.** Simplest possible, but we'd hand-roll image optimization, asset hashing, and shared layouts. With 4–6 pages, the friction adds up.
- **Eleventy.** Great for static sites, but more template-and-data oriented; less polished for the kind of interactive islands we want (video bg, scroll motion). Comparable simplicity to Astro for our needs.
- **Next.js (static export).** Overkill. We don't need React, and we'd ship more JS than necessary.

If you have strong feelings against Astro (e.g. you'd rather work in pure HTML/CSS for transparency, or you've used Eleventy before and prefer it), say so — none of these choices are wrong, they're just different tradeoffs.

**Secondary tooling:**
- **TypeScript** in loose mode. Catches typos in component props without forcing strict typing on us.
- **No CSS framework.** No Tailwind, no Bootstrap. The design is bespoke; bespoke CSS will be faster than fighting framework defaults.
- **Self-hosted fonts** via `@font-face`. No Google Fonts CDN — better privacy (no third-party tracking on a therapy site), better performance, no third-party uptime risk.

## Repo structure

```
/
├── astro.config.mjs
├── package.json
├── tsconfig.json
├── .nvmrc                       # pin Node LTS for reproducibility
├── public/
│   ├── images/                   # photos (committed; optimized at build time)
│   ├── video/                    # ambient video clip(s)
│   ├── fonts/                    # self-hosted webfonts
│   └── favicon.svg
├── src/
│   ├── pages/
│   │   ├── index.astro           # home
│   │   ├── about.astro
│   │   ├── services.astro        # services landing (single page for v1)
│   │   ├── contact.astro
│   │   └── 404.astro
│   ├── layouts/
│   │   └── Base.astro            # html/head/body shell, header, footer
│   ├── components/
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   ├── Hero.astro
│   │   ├── ApproachSection.astro
│   │   ├── ServicesGrid.astro
│   │   ├── EmpathyBeat.astro
│   │   ├── CTABanner.astro
│   │   ├── ScrollMotion.astro    # parallax island
│   │   └── VideoBackground.astro # ambient video island
│   ├── content/
│   │   ├── config.ts             # content collections schema
│   │   └── services/             # one .md per service
│   ├── styles/
│   │   ├── tokens.css            # design tokens (colors, type, spacing)
│   │   ├── reset.css
│   │   └── global.css
│   └── assets/
│       └── icons/                # SVG icons, imported at build time
└── docs/                          # already exists
```

## CSS architecture

- **Design tokens as CSS custom properties** in `src/styles/tokens.css`. Single source of truth for color, type, spacing, motion. Maps directly to [docs/brand/visual-style.md](brand/visual-style.md).
- **Fluid typography** via `clamp()` for headlines and body — avoids the usual breakpoint juggling.
- **Modern CSS for layout**: `grid`, `flex`, `subgrid` where supported. `container queries` for component-level responsiveness.
- **One global stylesheet** plus scoped component styles. No utility framework.
- **Color contrast verified** against WCAG AA before merge — sage button (`#7A8B5C`) on cream, white text on sage button, etc. I'll check each combination as we build.

## Build & deploy

- **Cloudflare Pages Git integration.** Connect the GitHub repo, auto-deploy `main` to production, auto-deploy PR branches to preview URLs.
- **Build command:** `npm run build` → outputs `dist/`.
- **Node version pinned** in `.nvmrc` and Cloudflare build config.
- **No env vars needed for v1** — everything is static.
- **Custom domain:** `releasewellnessca.com` added in Cloudflare Pages settings, DNS records updated at Namecheap. Preserve the Google Workspace MX records and email auth TXT records (SPF/DKIM/DMARC). Exact records will be written into [docs/domain-and-email-setup.md](domain-and-email-setup.md) at deploy time.

## Motion & accessibility

This is a therapy site. Visitors may include people with PTSD, vestibular sensitivity, migraine triggers, or trauma-related motion aversion. Accessibility isn't a checkbox — it's a meaningful brand value.

- **`prefers-reduced-motion: reduce`** wraps every animated element. Parallax stops, video swaps to its poster image, fades become instant.
- **Video background:** `muted` + `autoplay` + `loop` + `playsinline` with a `poster` image. IntersectionObserver pauses when scrolled out of view. Falls back to the poster on slow connections (`navigator.connection.saveData`) and on reduced-motion.
- **Semantic HTML:** `<header>`, `<nav>`, `<main>`, `<footer>`, `<section>` with proper `aria-labelledby`. One `<h1>` per page; logical h2/h3 hierarchy.
- **Skip-to-content link** as the first focusable element.
- **Visible focus rings** on every interactive element. No `outline: none` without a replacement.
- **Image alt text:** descriptive for content images, empty (`alt=""`) for purely decorative ones.
- **Color contrast:** WCAG AA at minimum, AAA for body text where feasible.

## Asset pipeline

- **Images:** Astro `<Image>` component → automatic WebP/AVIF, srcsets, lazy-loading below the fold. Source images committed at high resolution; build emits optimized variants.
- **Video:** encode the ambient clip to H.264 MP4 + WebM. Target ≤5 MB for ~10–15 seconds. Provide a poster image at the same dimensions. One clip in `public/video/`.
- **Icons:** SVG, either inlined per-component (best for animation/styling) or as a sprite (best for repeats). Inlined for v1.
- **Fonts:** self-hosted, `font-display: swap`. If using Cormorant Garamond + Inter (or whatever we land on), subset to Latin and the weights we actually use.

## Section-by-section build order

### Phase 1 — Scaffold (can do TODAY, no content needed)

1. `npm create astro@latest` in the repo, configure static output + MDX + TypeScript loose
2. Install Cloudflare adapter (`@astrojs/cloudflare`), connect Cloudflare Pages to the GitHub repo
3. Drop brand assets (logo SVG, photos, eventually video) into `public/`
4. Write `tokens.css` from [visual-style.md](brand/visual-style.md)
5. Self-host the chosen fonts; wire up `@font-face`
6. Build `Base.astro` layout with `Header`, `Footer` skeletons
7. Stub all pages (`index`, `about`, `services`, `contact`, `404`) with placeholder content
8. Push to GitHub → Cloudflare auto-deploys → live preview URL within minutes
9. Wire up `prefers-reduced-motion` plumbing and IntersectionObserver utility

End of Phase 1 we have: a deployed, branded, navigable site with placeholder content everywhere. Visible momentum, real URL to share with the practitioner.

### Phase 1 — actual outcome (2026-05-02)

Shipped and live at **https://releasewellness.pages.dev** (Cloudflare Pages, auto-deploys from `main` on `github.com/DstryThs/ReleaseWellness`). All 7 of the original "definitely do" items landed; three planned items were intentionally deferred:

- **`@astrojs/cloudflare` adapter not installed.** Astro's `output: 'static'` produces a plain `dist/` folder that Cloudflare Pages serves directly — no adapter needed. Adding it would only matter if we later want SSR or edge functions.
- **MDX / content collections not set up.** With three services on one page, file-per-service `.md` files would be premature abstraction. Page-component copy is fine for current volume; can split out when copy grows or when a non-developer needs to edit.
- **IntersectionObserver utility not built.** `prefers-reduced-motion` is wired into the global motion tokens in `tokens.css`, but the JS wrapper utility was deferred because there are no animated components yet — parallax and ambient video are both Phase 2 items gated on her video clip.

Other Phase-1 placeholders that still need her input before launch: real logo SVG (currently a placeholder favicon), real photography (hero is a sage rectangle), and all bracketed copy/contact/disclosure values listed in the Phase 2 table below.

### Phase 2 — Real content & polish (needs her inputs)

Each item below is unblocked when a specific piece of content arrives. They can be done in any order as content trickles in.

| Item | Blocked on |
|---|---|
| Footer disclosure (BBS supervision block) | Her ASW#, supervisor name, supervisor's LMFT# |
| All "Book a Consult" CTA targets | Her SimplePractice booking URL |
| Footer Psychology Today link | Her Psychology Today profile URL |
| Privacy Policy page | Privacy Policy text |
| Good Faith Estimate link in footer | GFE document or text |
| About page (final) | (Already have working copy in `copy-bank.md`; just plug in) |
| Services page (final) | Per-service descriptions beyond the intro line |
| Homepage hero copy | Her hero headline + subhead |
| Homepage approach section copy | Her version |
| Homepage empathy beat labels | Her four "you might be feeling…" prompts (or her replacement structure) |
| Homepage CTA banner copy | Her version |
| Ambient video section | Her video clip + which section it lives in |
| Real photography (if not using inspiration images long-term) | Whether she has her own photography, or licensing budget for stock |

### Phase 3 — Pre-launch checklist (right before going public)

- Color contrast audit (WCAG AA pass)
- Lighthouse audit (performance, accessibility, SEO, best practices)
- Manual keyboard navigation pass
- Manual reduced-motion test
- Cross-browser smoke test (Chrome, Safari, Firefox, mobile Safari, mobile Chrome)
- Verify DNS migration didn't break Google Workspace email — send + receive test emails before and after
- 404 page works
- Favicon and OG/social-share image render correctly
- Sitemap and robots.txt
- All BBS-required disclosure content accurate and present

## Decisions (resolved 2026-05-01)

Originals preserved verbatim with answers inline.

1. **Stack confirmation.** Astro, or do you want something different?
   → **Astro confirmed.**

2. **Multi-page vs. single-page anchored scroll.** I lean **multi-page** (separate `/about`, `/services`, etc.) since she has dedicated content for both. The inspiration mockup mixed signals on this. Confirm?
   → **Multi-page confirmed.**

3. **Per-service pages, or one Services page?** I lean **one Services page** for v1 (simpler, fine for SEO at this scale). Can split into per-service pages later if needed.
   → **One Services page for v1.** Splitting is a non-breaking change later if/when warranted.

4. **Contact form, or no contact form?** I lean **no form** — phone + email + SimplePractice link covers it, and avoids any risk of PHI accidentally landing in form submissions. Confirm?
   → **No form. Phone + email + SimplePractice link only.**

5. **Resources/blog?** The mockup nav had it; her assistant's outline did not. I lean **skip for v1**. Confirm?
   → **Skip for v1.** No `/resources` or `/blog` route; no nav entry.

6. **Where does the GitHub repo live?** Mike's personal GitHub, a new account for the practice, or somewhere else? Affects how we set up CI and who owns the deployment.
   → **Mike's personal GitHub.** Default to a private repo until launch.

7. **Cloudflare account ownership.** Same question — Mike's account, a new account in her name, or transferable later?
   → **Mike's personal Cloudflare account.** (Initially answered "new account in her name" on 2026-05-01; revised same day to consolidate ownership under Mike for simplicity. Both repo and host live under Mike; transferable to her later if needed.)

8. **Any analytics events** beyond what Cloudflare Web Analytics gives by default (pageviews + referrers)? I lean **no** — pageviews are enough, and event tracking on a therapy site is generally a privacy risk not worth the insight.
   → **No additional analytics.** Cloudflare Web Analytics defaults only.

### Notes on ownership (#6 + #7)

Both the source repo and the Cloudflare deploy live under Mike's accounts. Single-owner setup, no cross-account complexity. Implications:

- **Cloudflare ↔ GitHub authorization is in-account.** Cloudflare Pages installs the GitHub app on Mike's own repo — no cross-account permission grants needed.
- **Eventual handoff is a deliberate transfer.** If Mike's sister ever needs to take over solo, both the repo (GitHub transfer or fork) and the Cloudflare project (transfer to her account, or re-create and re-point DNS) would move at once. Mechanically simple, but it's a coordinated step rather than ambient ownership.
- **No external blocker for Phase 1 deploy.** Cloudflare Pages can be wired up the same day as scaffolding since Mike already has (or can create in seconds) his Cloudflare account.

## Out of scope for v1

To keep scope honest:
- No CMS (no Sanity, Contentful, etc.)
- No blog
- No newsletter signup
- No embedded online booking — link out to SimplePractice
- No authentication, no database
- No e-commerce
- No multi-language
- No A/B testing
- No third-party chat widgets

If any of these become important post-launch, we can add them deliberately rather than carry the complexity from day one.

## Status & next steps

**Plan approved 2026-05-01.** Ready to scaffold.

1. **Phase 1 — scaffold** (this session or next): Astro project, base layout, design tokens from `docs/brand/visual-style.md`, page stubs for `/`, `/about`, `/services`, `/contact`, `/404`. Push to a new private repo under Mike's GitHub.
2. **Cloudflare Pages wiring** (same session if Mike's Cloudflare account is ready): provision Pages, point it at the GitHub repo, get a `*.pages.dev` preview URL.
3. **Phase 2** — fold in real content as it arrives (see Phase 2 table above).
4. **Phase 3** — pre-launch checklist, then DNS cutover to Cloudflare Pages on `releasewellnessca.com` (preserving Google Workspace email records).
