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
- **Content (editable by Tanya)** — page copy lives in `src/content/pages/*.yaml` (`home`, `about`, `services`, `fees`, `contact`, plus `settings` for email/phone/address/social links), validated by Zod schemas in `src/content.config.ts`. Pages load it with `getPage()` / `getContact()` from `src/lib/content.ts`; body text is limited Markdown rendered per paragraph by `paragraphs()` in `src/lib/md.ts` (each `<p>` stays in the template so scoped styles apply); images are stored as `/src/assets/...` paths and resolved by `resolveImage()` in `src/lib/images.ts`. A bad value or missing image **fails the build** — that's the safety net, since CMS edits go straight to live.
- **CMS** — Sveltia CMS at `/admin/` (`public/admin/index.html` pins the version; `public/admin/config.yml` defines the editor fields and **must mirror `src/content.config.ts`** — change both together). GitHub backend + OAuth via a `sveltia-cms-auth` Cloudflare Worker. Uploads land in `src/assets/`, resized to WebP in the browser.
- **Data (locked, not in the CMS)** — `src/data/site.ts`: `BOOKING_URL` (the SimplePractice widget link; all booking CTAs import it) and `CREDENTIALS` (BBS registration + supervisor, used by the footer disclosure, About credentials note, `BookingDisclosure` and the Good Faith Estimate page — the one place to update when Tanya is licensed).
- **Styles** — `src/styles/`: `tokens.css` (design tokens: color, type, spacing, motion — single source of truth; maps to `docs/brand/`), `reset.css`, `global.css`. Components also use scoped `<style>` blocks.
- **Images** — `src/assets/` holds optimized source images used via Astro's `<Image>` (responsive `widths`/`srcset`, webp). `public/` holds static files served as-is (favicon, logo PNGs, `robots.txt`).

### Image optimization gotcha (important)

Astro's `<Image widths>` emits a correct responsive `srcset` but sets the `src` fallback (and any preload) to the **full-resolution** source. If the committed source is wider than the largest `widths` value, an oversized orphan variant gets shipped. **Fix (current): also pass `width={<largest widths value>}` on every `<Image>` (and to `getImage()` for preloads)** — the `src` fallback is then the largest listed variant no matter how big the source is, which matters now that Tanya uploads photos through the CMS. Older fix, still applied to the hero and headshot sources: downscale the committed file to the `widths` ceiling with sharp (read into a buffer first, then write back — sharp keeps the input open otherwise and the overwrite fails on Windows).

## Deployment

- **Host**: Cloudflare Pages (free tier), project `releasewellness`. Auto-deploys on push to `main`; PR branches get preview deploys. Build command `npm run build`, output `dist`.
- **Preview URL**: `releasewellness.pages.dev` (live now).
- **Custom domain**: `releasewellnessca.com` (registrar: Namecheap; **DNS moving to Cloudflare** at cutover — Cloudflare Pages requires apex domains to be on Cloudflare DNS). DNS cutover is the final pre-launch step. See `docs/dns-cutover-runbook.md`. Google Workspace email runs on the same domain; the email MX/TXT records must be reproduced and **verified in Cloudflare before the nameserver swap** (a single `smtp.google.com` MX + one Google verification TXT; no SPF/DKIM/DMARC currently).
- **Source**: GitHub `DstryThs/ReleaseWellness` (private).

## Conventions

- **Git workflow**: don't commit straight to `main` — branch, commit, then `--no-ff` merge into `main` and push (this triggers the Cloudflare deploy). Commit messages end with a `Co-Authored-By: Claude` trailer. **Exception: CMS content commits** (Tanya's edits via `/admin/`, touching `src/content/**` and `src/assets/`) land directly on `main` by design. Always `git pull` before starting code work.
- **Editable vs locked**: copy, lists, photos, SEO title/description and contact details are Tanya's (CMS). Layout, button labels, nav, eyebrows, `CREDENTIALS`, `BOOKING_URL`, and the Privacy / Good Faith Estimate text stay in code. Don't hardcode copy that exists in `src/content/` — read it from there.
- **No contact form / no PHI on the site** (deliberate — avoids form submissions becoming PHI). Contact is phone + email + the SimplePractice link only.
- **Analytics**: Cloudflare Web Analytics only (cookieless). No Google Analytics, no extra event tracking.
- When wiring a new booking/intake CTA, use `BOOKING_URL` from `src/data/site.ts` and open in a new tab.

## Key docs (read these to get oriented)

- `docs/build-plan.md` — **authoritative** phase/gate sequence and the live pre-launch checklist status. Check launch-readiness claims against this, not memory.
- `docs/dns-cutover-runbook.md` — turnkey steps for the go-live DNS cutover (with email-preservation guardrails).
- `docs/hosting-decisions.md` — final infra/stack decisions and rationale.
- `docs/domain-and-email-setup.md` — existing DNS/email records (what must not be disturbed).
- `docs/brand/` — brand assets, copy bank, visual style, imagery direction. Read before changing UI/content.

## Current status (launched 2026-06-15)

**The site is LIVE** at `https://releasewellnessca.com` (+ `www`), valid HTTPS, on Cloudflare DNS. The DNS cutover and Tanya's legal/BBS sign-off both landed 2026-06-15; email (Google Workspace MX) verified intact through the cutover. Post-launch checks green (canonical/OG, custom 404, sitemap, robots, booking CTA). Remaining **post-launch fast-follows**: the final logo (unblocks a real favicon + an `og:image` — currently a placeholder favicon and no social-share image), a human cross-browser/mobile smoke test, and a full keyboard tab-through. See `docs/build-plan.md` for the breakdown.
