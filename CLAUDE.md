# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project context

ReleaseWellness is the marketing/brochure website for a California-based therapy practice (the owner's sister, Tanya L. Hauer, MSW, ACSW — an Associate Clinical Social Worker practicing under LMFT supervision). It is a multi-page static site built with **Astro 5**, near launch as of mid-2026.

This is a **brochure site, not a clinical tool**: no PHI is collected here. All intake/scheduling hands off to SimplePractice (the "Book a Consult" CTAs link out to a third-party portal). Because the practitioner is BBS-regulated, CA Board of Behavioral Sciences marketing/disclosure rules apply — the footer carries the required supervision disclosure, and legal pages (Privacy, Good Faith Estimate) must be accurate.

## Build / dev / test commands

- `npm run dev` — local dev server (Astro)
- `npm run build` — production build to `dist/` (also optimizes images and generates the sitemap)
- `npm run preview` — serve the built `dist/` locally (used for Lighthouse runs)
- `npm run check` — `astro check` (type/diagnostics)

Node is pinned to **24** to match Cloudflare's build container (set via `NODE_VERSION=24` there and `.nvmrc` locally); Astro 5 fails on older Node.

## Architecture

Static Astro site, `output: 'static'`, multi-page (no SPA/router). Five primary nav pages plus legal pages and a 404.

- **Pages** — `src/pages/*.astro`: `index`, `about`, `services`, `fees`, `contact`, `privacy`, `good-faith-estimate`, `404`. File-based routing.
- **Layout** — `src/layouts/Base.astro`: the single shared shell (`<head>`, meta/OG tags, canonical, skip link, Header, Footer). All pages wrap their content in it.
- **Components** — `src/components/`: `Header.astro` (sticky nav + logo mark + CTA), `Footer.astro` (contact, social, BBS disclosure, legal links), `BookingDisclosure.astro` (note shown near booking CTAs).
- **Data** — `src/data/site.ts`: centralized constants, notably `BOOKING_URL` (the SimplePractice widget link). All booking CTAs import this — change it in one place.
- **Styles** — `src/styles/`: `tokens.css` (design tokens: color, type, spacing, motion — single source of truth; maps to `docs/brand/`), `reset.css`, `global.css`. Components also use scoped `<style>` blocks.
- **Images** — `src/assets/` holds optimized source images used via Astro's `<Image>` (responsive `widths`/`srcset`, webp). `public/` holds static files served as-is (favicon, logo PNGs, `robots.txt`).

### Image optimization gotcha (important)

Astro's `<Image widths>` emits a correct responsive `srcset` but sets the `src` fallback (and any preload) to the **full-resolution** source. If the committed source is wider than the largest `widths` value, an oversized orphan variant gets shipped. **Fix: downscale each committed source asset to the largest value in that image's `widths` array.** Already applied to the hero and headshot. Use a sharp one-liner (read the file into a buffer first, then write back — sharp keeps the input open otherwise and the overwrite fails on Windows).

## Deployment

- **Host**: Cloudflare Pages (free tier), project `releasewellness`. Auto-deploys on push to `main`; PR branches get preview deploys. Build command `npm run build`, output `dist`.
- **Preview URL**: `releasewellness.pages.dev` (live now).
- **Custom domain**: `releasewellnessca.com` (registrar: Namecheap; **DNS moving to Cloudflare** at cutover — Cloudflare Pages requires apex domains to be on Cloudflare DNS). DNS cutover is the final pre-launch step. See `docs/dns-cutover-runbook.md`. Google Workspace email runs on the same domain; the email MX/TXT records must be reproduced and **verified in Cloudflare before the nameserver swap** (a single `smtp.google.com` MX + one Google verification TXT; no SPF/DKIM/DMARC currently).
- **Source**: GitHub `DstryThs/ReleaseWellness` (private).

## Conventions

- **Git workflow**: don't commit straight to `main` — branch, commit, then `--no-ff` merge into `main` and push (this triggers the Cloudflare deploy). Commit messages end with a `Co-Authored-By: Claude` trailer.
- **No contact form / no PHI on the site** (deliberate — avoids form submissions becoming PHI). Contact is phone + email + the SimplePractice link only.
- **Analytics**: Cloudflare Web Analytics only (cookieless). No Google Analytics, no extra event tracking.
- When wiring a new booking/intake CTA, use `BOOKING_URL` from `src/data/site.ts` and open in a new tab.

## Key docs (read these to get oriented)

- `docs/build-plan.md` — **authoritative** phase/gate sequence and the live pre-launch checklist status. Check launch-readiness claims against this, not memory.
- `docs/dns-cutover-runbook.md` — turnkey steps for the go-live DNS cutover (with email-preservation guardrails).
- `docs/hosting-decisions.md` — final infra/stack decisions and rationale.
- `docs/domain-and-email-setup.md` — existing DNS/email records (what must not be disturbed).
- `docs/brand/` — brand assets, copy bank, visual style, imagery direction. Read before changing UI/content.

## Current status (mid-2026)

Site is functionally complete and technical pre-launch checks are largely green (Lighthouse: a11y/best-practices/SEO 100 across pages; contrast, sitemap, reduced-motion, 404 done). Remaining gates before public launch: practitioner sign-off on legal/BBS content, the final logo (which unblocks a real favicon + an OG/social-share image), the DNS cutover, and human cross-browser/keyboard + email-deliverability checks. See `docs/build-plan.md` for the current breakdown.
