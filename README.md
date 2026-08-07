# Lucid Guardian — site

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
4. **Set the contact address.** `src/page.html` still has `mailto:REPLACE-WITH-YOUR-EMAIL`.

## Screenshots

Drop PNGs into `assets/`, then in `src/page.html` replace each placeholder:

```html
<!-- from -->
<div class="shot-slot"><span class="eyebrow">Capture in preparation</span></div>

<!-- to -->
<img src="assets/dashboard.png" alt="Dashboard showing recovery score ring, brain state and vitals grid">
```

The frames are sized 9:19.5, so capture on a phone at default resolution and they will fit.
Rebuild afterwards.

## Deploying to GitHub Pages

**Option A — its own repo (recommended).**

```bash
git init
git add .
git commit -m "Lucid Guardian site"
gh repo create lucid-guardian-site --public --source=. --push
```

Then in the repo: **Settings → Pages → Source: Deploy from a branch → `main` / `root`**.
Live at `https://<username>.github.io/lucid-guardian-site/` within a minute or two.

**Option B — a `/docs` folder in an existing repo.** Copy these files into `docs/` and set
**Settings → Pages → Source: `main` / `/docs`**. Useful if you would rather not manage a second repo.

## Custom domain

Buy the domain at Cloudflare Registrar (at-cost, no renewal markup), then:

1. Create a file named `CNAME` in this folder containing only the bare domain, e.g. `lucidguardian.com`
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
