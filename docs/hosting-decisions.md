# Hosting & infrastructure — final decisions

Final stack for Release Wellness. The earlier brainstorm in [hosting-planning-session.md](hosting-planning-session.md) is the working notes that led here; this file is the source of truth.

## Stack at a glance

| Layer | Choice | Status | Cost |
|---|---|---|---|
| Domain registrar | Namecheap | Done — `releasewellnessca.com` | Already paid |
| DNS | Namecheap (Advanced DNS) | Done for email; will add web records later | $0 |
| Email | Google Workspace (single-MX) | Done | Existing subscription |
| Source control | GitHub | Done — `github.com/DstryThs/ReleaseWellness` (Mike's personal account, private) | Free |
| Web hosting | **Cloudflare Pages** (free tier) | Done — `releasewellness.pages.dev` (Mike's personal account) | $0 |
| Analytics | Cloudflare Web Analytics | TBD — not yet enabled; opt-in separate from Pages | $0 |
| Intake / scheduling | SimplePractice | Existing account | Existing subscription |
| Directory listing | Psychology Today | Profile exists | Existing subscription |

## Why Cloudflare Pages over Vercel

The planning session recommended Vercel Hobby. We switched to Cloudflare Pages for two reasons:

1. **Vercel Hobby's ToS restricts it to personal, non-commercial use.** Release Wellness, LLC is a commercial entity. Compliant Vercel use would require Vercel Pro at $20/user/month.
2. **Bandwidth.** The site will include an ambient video background plus nature photography, ~5–8 MB per page view. Vercel Hobby caps at 100 GB/month; Cloudflare Pages has effectively unlimited bandwidth for static content on the free tier.

Cloudflare Pages provides the same essentials — Git-push deploys, global CDN, automatic HTTPS, custom domains — without the commercial-use restriction or bandwidth ceiling.

## Build & deploy flow

1. Build the site locally
2. Push to GitHub
3. Cloudflare Pages auto-deploys on push to `main`
4. Preview deploys auto-generated for PR branches
5. Custom domain (`releasewellnessca.com`) added in Cloudflare Pages, DNS records updated at Namecheap

## Cloudflare Pages build configuration

Concrete settings used when wiring up the Pages project on 2026-05-02. Capture here so the project can be re-created from scratch if ever needed (account transfer, accidental deletion, etc.) without re-deriving them.

| Setting | Value |
|---|---|
| Project name | `releasewellness` |
| Connected repo | `DstryThs/ReleaseWellness` (GitHub) |
| Production branch | `main` |
| Framework preset | Astro |
| Build command | `npm run build` |
| Build output directory | `dist` |
| Root directory | (blank — repo root) |
| Environment variable | `NODE_VERSION=24` |

The `NODE_VERSION` env var is the **non-obvious** one. Without it, Cloudflare's build container defaults to an older Node and Astro 5 fails immediately with a "Node.js vXX is not supported" error. Pinning to `24` matches the local `.nvmrc` and keeps local + CI in sync.

## DNS coordination — preserve email when adding the website

When we add the website's DNS records at Namecheap, **the existing Google Workspace MX records must not be touched**. The current email setup uses a single-MX configuration (`smtp.google.com`, priority 1) — see [domain-and-email-setup.md](domain-and-email-setup.md).

The records we'll add at Namecheap when wiring up Cloudflare:
- `A` or `CNAME` at the apex / `www` pointing to Cloudflare Pages (Cloudflare provides the exact target)
- Optionally, Cloudflare's TXT verification record

**Records that must remain untouched:**
- The MX record for Google Workspace
- Any existing TXT records for SPF / DKIM / DMARC (email authentication)

We'll write the exact records into [domain-and-email-setup.md](domain-and-email-setup.md) once we go to deploy.

## Privacy & compliance posture

This site is a **marketing/brochure site**, not a clinical tool. The clinical workflow lives in SimplePractice.

- **No PHI collected on the website.** All intake routes to SimplePractice, which has its own HIPAA-compliant infrastructure and BAA with the practitioner.
- **Contact form** (if we add one) collects only name, email, and a generic message. Even fields like "what brings you in" become PHI in this context and must not be on this site.
- **Analytics** uses Cloudflare Web Analytics — privacy-respecting, cookieless, no third-party tracking. **No Google Analytics.**
- **Required footer disclosures**: Privacy Policy (TBD — needs to be written), Good Faith Estimate (US federal requirement for healthcare providers), Psychology Today profile link.

## Open items

- [x] ~~Push initial scaffold to a GitHub repo~~ — done 2026-05-02, `github.com/DstryThs/ReleaseWellness`
- [x] ~~Confirm Cloudflare account ownership~~ — resolved 2026-05-01 (Mike's personal account; see [build-plan.md](build-plan.md) decision #7)
- [ ] Privacy Policy content — typically generated from a template tailored to a CA-licensed therapy practice; review with the practitioner before publishing
- [ ] Good Faith Estimate document — she likely already has one she gives to clients; we need a copy or a link target for the footer
- [ ] Get the SimplePractice booking URL she wants CTAs to point at
- [ ] Confirm the Psychology Today profile URL for the footer link
- [ ] Enable Cloudflare Web Analytics on the Pages project (separate from the deploy itself)
- [ ] Add custom domain `releasewellnessca.com` to the Pages project + cut over DNS at Namecheap (Phase 3, before public launch)
