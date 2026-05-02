# Domain & Email Setup — ReleaseWellnessCA.com

Reference notes from initial setup of the domain with Google Workspace.

## Accounts & providers

- **Domain**: `releasewellnessca.com`
- **Registrar / DNS host**: Namecheap (Advanced DNS tab manages all records)
- **Email**: Google Workspace (Gmail on the custom domain)

## DNS records configured

All records live on Namecheap → Domain List → Manage → **Advanced DNS**.

### Domain verification (TXT)

Added in **Host Records**:

| Field | Value |
|---|---|
| Type | TXT Record |
| Host | `@` |
| Value | `google-site-verification=...` (string copied from the Google Workspace setup wizard) |
| TTL | Automatic |

### Gmail MX record

Google Workspace's current setup wizard uses a **single** MX record (not the legacy 5-record `ASPMX.L.GOOGLE.COM` setup that Namecheap's "Gmail" preset adds).

In **Mail Settings**, set the dropdown to **Custom MX** (not "Gmail"), then add:

| Field | Value |
|---|---|
| Type | MX Record |
| Host | `@` |
| Mail Server (Value) | `smtp.google.com` |
| Priority | `1` |
| TTL | Automatic |

Click **Save All Changes**.

## Gotchas encountered

- **Google verification string** comes from the Google Workspace Admin setup wizard at admin.google.com — Namecheap's instructions reference "a string provided by Google" but don't say where to find it.
- **Namecheap's "Gmail" preset is outdated.** It auto-adds the legacy 5 MX records. Google's current wizard expects the single `smtp.google.com` record, so use **Custom MX** instead.
- **MX Record type is hidden** from the Host Records → Type dropdown until Mail Settings is switched to **Custom MX**. The two sections are linked.
- **Switching to Custom MX adds a blank MX row immediately** — fill in Host / Mail Server / Priority before clicking Save All Changes, otherwise the save is blocked.
- **Propagation** can take 30 min to a few hours. If Google's "Confirm" / "Verify" button fails, wait and retry.

## Verification steps after DNS saves

1. Return to the Google Workspace setup wizard.
2. Check the "I have updated the code on my domain host" box.
3. Click **Confirm** (for MX) or **Verify** (for TXT).
4. Once verified, create the user mailbox in Workspace Admin and send a test email in/out to confirm.
