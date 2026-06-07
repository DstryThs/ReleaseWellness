# DNS cutover runbook — going live on releasewellnessca.com

Step-by-step to point `releasewellnessca.com` at the Cloudflare Pages site **without breaking Google Workspace email**. Companion to [hosting-decisions.md](hosting-decisions.md) (§ DNS coordination) and [domain-and-email-setup.md](domain-and-email-setup.md) (existing email records).

**Strategy:** keep DNS at Namecheap (do *not* move nameservers to Cloudflare). We only *add* web records for the apex + `www`; the existing email records stay exactly as they are. This is the lower-risk path because the sensitive MX/TXT email records never move.

**Target:** the Pages project deploys at `releasewellness.pages.dev` — that's the value the web records point at. (Confirm the exact target Cloudflare shows when you add the custom domain, in case it differs.)

---

## Phase A — Stage it (safe to do anytime, no public exposure)

1. Cloudflare dashboard → Pages → **`releasewellness`** project → **Custom domains** → **Set up a custom domain**.
2. Add `releasewellnessca.com`. Then repeat and add `www.releasewellnessca.com`.
3. Cloudflare will show the domain as **pending** with DNS instructions. Because our nameservers are at Namecheap, nothing goes live yet — the domain just waits for the records in Phase B. Note the CNAME target it gives (expected: `releasewellness.pages.dev`).
4. *(Optional, recommended now)* Enable **Cloudflare Web Analytics** for the project. This also makes the Privacy Policy's "cookieless analytics" claim accurate.

> ⚠️ **Do not proceed to Phase B until Tanya has signed off** on the Privacy Policy, Good Faith Estimate, aromatherapy copy, and the BBS disclosure block. Phase B is the point the site becomes public and indexable.

---

## Phase B — The cutover (the public-launch step)

At **Namecheap → Domain List → Manage → Advanced DNS**:

### Remove the parking records
Namecheap ships default parking entries that will conflict. Delete:
- The `CNAME` record `www` → `parkingpage.namecheap.com` (or similar)
- Any `URL Redirect` record on `@`
- Any `A` record on `@` pointing at a Namecheap parking IP

### Add the web records
| Type | Host | Value | TTL |
|---|---|---|---|
| ALIAS | `@` | `releasewellness.pages.dev` | Automatic |
| CNAME | `www` | `releasewellness.pages.dev` | Automatic |

> Namecheap's **ALIAS** type is required for the apex (`@`) because a plain CNAME isn't allowed at the root. If Cloudflare's instructions name a different target than `releasewellness.pages.dev`, use theirs.

### ❌ Do NOT touch these (email — leave exactly as-is)
- `MX` `@` → `smtp.google.com`, priority `1`
- `TXT` `@` → `google-site-verification=...`
- Any `TXT` for SPF / DKIM / DMARC

### Finish
- Back in Cloudflare Pages, the custom domain status flips to **Active** and an HTTPS cert is issued automatically (minutes up to ~1 hour).
- Propagation can take 30 min–few hours.

---

## Phase C — Email guardrail test (do this around the change)

The whole point of the careful record handling is that email keeps working. Test both directions, before and after.

**Before changing any records:**
- [ ] Send a test email **to** `tanya@releasewellnessca.com` from an outside address (e.g. a personal Gmail) — confirm it arrives.
- [ ] Send a test email **from** the Workspace account to an outside address — confirm it arrives.

**After DNS propagates:**
- [ ] Repeat both tests.
- [ ] If either fails: re-check that the MX and email TXT records are present and unchanged. Web record changes should not affect them; if they're intact, wait for propagation and retry.

---

## Phase D — Post-cutover web verification

- [ ] `https://releasewellnessca.com` loads the site, valid HTTPS (no cert warning)
- [ ] `https://www.releasewellnessca.com` loads / redirects correctly
- [ ] A few internal links + the SimplePractice "Book a Consult" CTA work
- [ ] `https://releasewellnessca.com/404-test` shows the custom 404
- [ ] `https://releasewellnessca.com/sitemap-index.xml` resolves
- [ ] Canonical tags / OG URLs now resolve to the real domain (they're built from `site` in astro.config.mjs, already set to `https://releasewellnessca.com`)

---

## Rollback

Web-only rollback is clean: removing the ALIAS (`@`) and CNAME (`www`) records reverts the site. Because the email records were never touched, mail is unaffected throughout.
