# Prodrome Guardian — site

Static one-page site. No build tooling, no dependencies, no framework. One HTML file.

```
src/page.html   ← edit this
_head.html      ← <head>: metadata, favicon, reset
build.sh        ← wraps page.html in _head.html to produce index.html
index.html      ← generated, commit it (GitHub Pages serves this)
assets/         ← screenshots and the social card
.nojekyll       ← tells GitHub Pages to serve files as-is
```

`src/page.html` is a fragment with no `<html>` or `<head>`, because that is the format the
Claude artifact host expects. `build.sh` wraps it so the same content works as a standalone
site. Edit the source, run the build, commit both.

```bash
./build.sh
```

## Before you publish

Three things in `_head.html` are marked `«EDIT»` and one is in the page itself.

1. **Remove the `noindex`.** The page ships with `<meta name="robots" content="noindex, nofollow">`
   so a half-finished clinical prototype page does not get indexed. Delete that line when ready.
2. **Set the canonical URL.** Uncomment `<link rel="canonical">` and point it at the live URL.
   Leave it commented rather than guessing — a wrong canonical is worse than none.
3. **Add a social card.** Put a 1200×630 PNG at `assets/og.png`, then uncomment the `og:image`,
   `og:url` and `twitter:card` block. Without it, links shared in Slack or WhatsApp render bare.
4. **Connect the contact form.** `src/page.html` still has `REPLACE-WITH-FORM-ID`. See below.

## Screenshots

The page already references five files. Save them into `assets/` with these exact names:

| File | Screen |
|---|---|
| `assets/dashboard.png` | Recovery score, NEWS2 badge, brain state |
| `assets/brain.png`     | Live waveform, band power, state timeline |
| `assets/vitals.png`    | Vital gauges and trends |
| `assets/alerts.png`    | Escalation chain, thresholds, contacts |
| `assets/recovery.png`  | Milestones and daily check-in |

No markup change needed. Until a file exists the frame shows a placeholder, and it swaps to the
real image as soon as the PNG is committed. Alt text is already written for each one.

Capture at default phone resolution; the frames are 9:19.5 and crop to fit.

## Contact form

The pilot CTA opens a form (name, email, optional phone, optional hospital, message) rather than
exposing an address, so the inbox stays private.

`src/page.html` ships with `action="https://formspree.io/f/REPLACE-WITH-FORM-ID"`. To connect it:

**Formspree** — create a form at formspree.io, copy the endpoint, paste it as the `action`.
The free tier covers 50 submissions a month.

**Web3Forms** — an alternative with no account. Get an access key at web3forms.com, set
`action="https://api.web3forms.com/submit"` and add one hidden field:

```html
<input type="hidden" name="access_key" value="YOUR-KEY">
```

Both work with the markup as written. The form degrades gracefully: with JavaScript it submits in
place and shows an inline confirmation; without it the browser posts natively.

A honeypot field catches basic bots. Validation is inline with linked error messages, and the
submit button locks only while a request is in flight.

## Deploying to GitHub Pages

**Option A — its own repo (recommended).**

```bash
git init
git add .
git commit -m "Prodrome Guardian site"
gh repo create prodrome-guardian --public --source=. --push
```

Then in the repo: **Settings → Pages → Source: Deploy from a branch → `main` / `root`**.
Live at `https://<username>.github.io/prodrome-guardian/` within a minute or two.

**Option B — a `/docs` folder in an existing repo.** Copy these files into `docs/` and set
**Settings → Pages → Source: `main` / `/docs`**. Useful if you would rather not manage a second repo.

## Custom domain

Buy the domain at Cloudflare Registrar (at-cost, no renewal markup), then:

1. Create a file named `CNAME` in this folder containing only the bare domain, e.g. `prodromeguardian.com`
2. At your DNS provider, add `ALIAS`/`ANAME` (or four `A` records) pointing the apex at GitHub Pages,
   and a `CNAME` for `www` pointing at `<username>.github.io`
3. In **Settings → Pages**, enter the domain and tick **Enforce HTTPS**

The certificate takes a few minutes. Update the canonical and `og:url` to match once it resolves.

## Notes

- Everything is inline: no external fonts, scripts, images or CDN calls. The page works offline
  and behind restrictive hospital networks.
- Tabs are progressive enhancement. With JavaScript disabled all four panels render stacked,
  and printing expands them regardless.
- Tabs are deep-linkable: `#evidence`, `#how-it-works`, `#who-its-for`, `#status`.
- The page respects `prefers-color-scheme` and `prefers-reduced-motion`.
