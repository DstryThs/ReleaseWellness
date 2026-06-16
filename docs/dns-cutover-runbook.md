# DNS cutover runbook — going live on releasewellnessca.com

Step-by-step to point `releasewellnessca.com` at the Cloudflare Pages site **without breaking Google Workspace email**. Companion to [hosting-decisions.md](hosting-decisions.md) (§ DNS coordination) and [domain-and-email-setup.md](domain-and-email-setup.md) (existing email records).

> **Strategy changed 2026-06-07 — we now move DNS to Cloudflare.**
> The earlier version of this runbook kept nameservers at Namecheap and only *added* an
> `ALIAS @ → releasewellness.pages.dev` web record. That doesn't work: **Cloudflare Pages
> requires an apex (root) custom domain to be a zone on Cloudflare's own DNS** — it will only
> verify *subdomains* against an external provider. The keep-Namecheap workaround (serve on
> `www`, redirect the apex) can't serve `https://releasewellnessca.com` with a valid TLS cert
> (Namecheap's URL-redirect doesn't cover HTTPS on the bare apex), and the apex is our canonical
> URL (`site` in `astro.config.mjs`). So we move DNS authority to Cloudflare. Email is preserved
> by importing and **verifying** the email records in Cloudflare *before* the nameserver switch —
> see [hosting-decisions.md](hosting-decisions.md) § DNS coordination for the rationale.

**Strategy:** move the domain's nameservers from Namecheap to Cloudflare so Cloudflare DNS serves
both the apex and `www` natively (automatic HTTPS on both). The Google Workspace email records are
recreated/verified in Cloudflare **before** the nameserver swap, so mail never has a gap. The
registrar stays Namecheap; only the *nameservers* move.

**Target:** the Pages project deploys at `releasewellness.pages.dev` — that's the project the
custom-domain records point at. (Confirm the exact target Cloudflare shows when you add the custom domain, in case it differs.)

## Email records that MUST survive (live audit, 2026-06-07)

This is the complete set currently published — verify all of it lands in Cloudflare before Phase C.

| Type | Host | Value | TTL |
|---|---|---|---|
| MX | `@` | `smtp.google.com`, priority `1` | Auto |
| TXT | `@` | `google-site-verification=VLGt6LXYmgG4BOJsZu4hj6ynzP3aO9zQPOBiSq8polI` | Auto |

> **No SPF / DKIM / DMARC are currently published** (`_dmarc` is NXDOMAIN; `google._domainkey`
> is empty). There is nothing else to preserve. If any of those get added at Namecheap before the
> cutover, re-run the audit and carry them over too. (Adding SPF + DMARC later is a worthwhile
> deliverability improvement, but it's out of scope for the cutover.)

**Current nameservers (for rollback):** `dns1.registrar-servers.com` / `dns2.registrar-servers.com` (Namecheap BasicDNS).

---

## Phase 0 — Pre-flight audit (do first, read-only)

> **Who does what:** 🤖 **Claude** — just ask and I run these. Read-only lookups; they change nothing.

Confirm nothing has changed since the audit above before you start:

```
nslookup -type=MX  releasewellnessca.com 8.8.8.8
nslookup -type=TXT releasewellnessca.com 8.8.8.8
nslookup -type=NS  releasewellnessca.com 8.8.8.8
```

Expect the single `smtp.google.com` MX, the `google-site-verification` TXT, and the two
`registrar-servers.com` nameservers. Record the nameserver pair — it's your rollback target.

---

## Phase A — Onboard the zone to Cloudflare (safe, no public exposure)

> **Who does what:** 🧑 **You** click through the Cloudflare wizard (it needs your login); 🤖 **Claude** verifies the scanned records — paste the records screen to me before you continue past it.

Clicking **"Begin DNS transfer"** (on the Pages custom-domain screen) opens Cloudflare's
**"Add a site"** wizard in a new tab. Walk it through:

1. **Confirm the domain.** `releasewellnessca.com` is pre-filled — continue.
2. **Select a plan — choose Free.** The wizard shows the paid plans first; scroll down and pick
   the **Free $0/mo** plan, then continue. (No credit card required for Free.)
3. **Review the scanned DNS records.** Cloudflare auto-scans Namecheap and lists what it found.
   **Confirm both email records are present** — if either is missing, add it with **+ Add record**:
   - `MX` `@` → `smtp.google.com`, priority `1`
   - `TXT` `@` → `google-site-verification=VLGt6LXYmgG4BOJsZu4hj6ynzP3aO9zQPOBiSq8polI`

   Both must be **DNS only / grey cloud** (Cloudflare can't proxy MX/TXT anyway). Do not continue
   until both are present and correct. Continue.
4. **Cloudflare shows your two assigned nameservers** (e.g. `xxxx.ns.cloudflare.com`).
   **Write both down** — you'll enter them at Namecheap in Phase C.

   > 🛑 **STOP HERE. Do NOT change your nameservers yet.** Cloudflare's screen will instruct you to
   > update nameservers at your registrar "to complete the setup," and the zone will sit at
   > **"Pending Nameserver Update."** That pending state is **expected and correct** — leaving it
   > pending changes nothing about live DNS or email (Namecheap is still authoritative). The
   > nameserver change is the public go-live step (Phase C) and waits for Tanya's sign-off.

5. *(Optional, recommended now)* Enable **Cloudflare Web Analytics** for the Pages project. This
   also makes the Privacy Policy's "cookieless analytics" claim accurate.

---

## Phase B — Add the Pages custom domains (still safe)

> **Who does what:** 🧑 **You** — type two domain names into your Pages project. 🤖 **Claude** confirms they're attached correctly if you paste the result.

1. Cloudflare dashboard → Pages → **`releasewellness`** project → **Custom domains**.
2. Add `releasewellnessca.com`, then add `www.releasewellnessca.com`. Because the zone now exists
   in your account (Phase A), Cloudflare auto-creates the proxied web records pointing at the Pages
   project — no manual `ALIAS`/`CNAME` needed.
3. The custom domains will show **pending** until the nameservers move in Phase C. No public
   exposure yet (the live domain still resolves via Namecheap).

> If Cloudflare won't let you attach the **apex** (`releasewellnessca.com`) while the zone is still
> "Pending Nameserver Update," that's fine — it just means the apex must wait for an active zone.
> Do Phase C first, then come back and add both custom domains immediately after. (`www` may attach
> while pending; the apex is the one that can require an active zone.) Either ordering is safe.

> ⚠️ **Do not proceed to Phase C until Tanya has signed off** on the Privacy Policy, Good Faith
> Estimate, aromatherapy copy, and the BBS disclosure block. Phase C is the point the site becomes
> public and indexable.

---

## Phase C — The cutover (the public-launch step, point of no return)

> **Who does what:** 🧑 **You** — the one real action: change the nameservers at Namecheap. 🤖 **Claude** hands you the exact two values to paste. Don't do this until Tanya has signed off.

This is the **single action** that moves DNS authority. Everything before it is reversible.

At **Namecheap → Domain List → `releasewellnessca.com` → Manage → Nameservers**:

1. Change the dropdown from **Namecheap BasicDNS** to **Custom DNS**.
2. Enter the **two Cloudflare nameservers** from Phase A.
3. **Save.**

- Back in Cloudflare, the zone flips to **Active** and the Pages custom domains flip to **Active**;
  HTTPS certs for apex + `www` issue automatically (minutes up to ~1 hour).
- Propagation can take 30 min–few hours.

### ❌ Do NOT during the move
- Don't delete the Cloudflare-side MX / `google-site-verification` TXT records — they were verified
  in Phase A and are what keeps email working once Cloudflare becomes authoritative.

---

## Phase D — Email guardrail test (do this around the change)

> **Who does what:** 🧑 **You** send the two test emails (in + out). 🤖 **Claude** runs the `nslookup` checks.

The whole point of the pre-flight verify is that email keeps working. Test both directions, before and after.

**Before changing nameservers (Phase C):**
- [ ] Send a test email **to** `tanya@releasewellnessca.com` from an outside address (e.g. a personal Gmail) — confirm it arrives.
- [ ] Send a test email **from** the Workspace account to an outside address — confirm it arrives.

**After DNS propagates:**
- [ ] `nslookup -type=NS releasewellnessca.com` returns the Cloudflare pair (not `registrar-servers.com`).
- [ ] `nslookup -type=MX releasewellnessca.com` still returns `smtp.google.com`.
- [ ] Repeat both send/receive tests.
- [ ] If either fails: re-check the MX and `google-site-verification` TXT in the **Cloudflare** DNS
      table are present and unchanged, then wait for propagation and retry.

---

## Phase E — Post-cutover web verification

> **Who does what:** 🤖 **Claude** can load and check the URLs/sitemap; 🧑 **You** eyeball the live site renders right.

- [ ] `https://releasewellnessca.com` loads the site, valid HTTPS (no cert warning)
- [ ] `https://www.releasewellnessca.com` loads / redirects correctly
- [ ] A few internal links + the SimplePractice "Book a Consult" CTA work
- [ ] `https://releasewellnessca.com/404-test` shows the custom 404
- [ ] `https://releasewellnessca.com/sitemap-index.xml` resolves
- [ ] Canonical tags / OG URLs now resolve to the real domain (they're built from `site` in astro.config.mjs, already set to `https://releasewellnessca.com`)

---

## Rollback

> **Who does what:** 🧑 **You** — one dropdown change at Namecheap reverts everything.

Clean and DNS-only: at Namecheap → Nameservers, switch back from **Custom DNS** to **Namecheap
BasicDNS** (or re-enter `dns1.registrar-servers.com` / `dns2.registrar-servers.com`). DNS authority
returns to Namecheap with its original, untouched records — email included — so mail is unaffected
throughout. (Cloudflare keeps the zone config in case you want to retry; it just stops being
authoritative.)
