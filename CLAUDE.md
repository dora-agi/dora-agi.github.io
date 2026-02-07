# CLAUDE.md - Dora AGI Website

## Project Overview
Static website for doratech.cn (Dora AI Platform). Served via Nginx on Ubuntu. All pages are standalone HTML files with inline CSS — no build step, no framework.

## Key Files
- `index.html` — Main site (hero, apps showcase, about, contact, footer)
- `apps/dora.html` — Dora app detail page (features, screenshots, CTA)
- `privacy.html`, `terms.html` — Legal pages (bilingual zh/en)
- `sitemap.xml` — All pages listed
- `resources/fonts/fonts.css` — @font-face declarations for all self-hosted fonts
- `resources/fonts/*.woff2, *.woff` — Font files (Plus Jakarta Sans, DM Sans, Inter)
- `resources/*.png` — App screenshots and icons

## Design System

### Aesthetic Direction
This site was deliberately designed to avoid generic "AI slop" aesthetics. When making changes, preserve these intentional choices:
- **NO** pill-shaped buttons (use 8px radius, dark background)
- **NO** colored badge pills for section labels (use muted gray uppercase text)
- **NO** colored top-bars on cards (use clean borders only)
- **NO** floating/bouncing decorative animations
- **NO** gradient text effects (use solid dark colors)
- **NO** Inter font as body text (it's kept as legacy fallback only)

### CSS Custom Properties (Design Tokens)
All pages share the same token system declared in each file's `<style>`:
```css
--bg-cream: #FAF8F5;        /* Page background */
--text-primary: #1A1A1A;     /* Body text, headings, buttons */
--text-secondary: #6B7280;   /* Muted text */
--accent-coral: #E8583A;     /* Accent color (sparingly) */
--accent-lavender: #7B6CB0;  /* Secondary accent */
--radius-sm: 8px;            /* Buttons, small elements */
--radius-md: 12px;           /* Cards */
--radius-lg: 16px;           /* Larger containers */
--shadow-soft: 0 2px 12px rgba(0,0,0,0.04);  /* Subtle shadows */
```

### Typography
- **Body font**: `'DM Sans'` — geometric but warm, avoids Inter's genericness
- **Heading font**: `'Plus Jakarta Sans'` — used for h1/h2/section titles
- **Fallback chain**: `..., -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`
- Chinese text uses system fonts (PingFang SC, Microsoft YaHei) via fallback

### Visual Texture
- Grain overlay on `body::after` — SVG `feTurbulence` noise at `opacity: 0.025`
- Dot grid pattern in hero sections — CSS `radial-gradient` at 28px spacing
- Shadows are very subtle: `rgba(0,0,0,0.04)` to `rgba(0,0,0,0.1)`

### Bilingual Architecture
- Language toggle via `lang-zh`/`lang-en` CSS classes on `<html>` element
- Stored in `localStorage('language')`, defaults to Chinese
- Both languages present in HTML: `<span class="lang-zh">中文</span><span class="lang-en">English</span>`
- CSS hides inactive language: `.lang-zh .lang-en { display: none }`

## Fonts (Self-Hosted)
**Critical**: Google Fonts CDN is completely blocked in China. All fonts MUST be self-hosted.

Fonts are downloaded from [google-webfonts-helper](https://gwfh.mranftl.com/fonts/) API in woff2 + woff formats, stored in `resources/fonts/`, and declared in `fonts.css`.

Current families:
- Plus Jakarta Sans: 400, 500, 600, 700, 800
- DM Sans: 400, 500, 600, 700
- Inter: 300, 400, 500, 600 (legacy, kept for backward compat)

To add a new font weight/family:
1. Download from `https://gwfh.mranftl.com/api/fonts/{font-id}?download=zip&subsets=latin&variants={weights}`
2. Place woff2/woff files in `resources/fonts/`
3. Add @font-face declarations to `fonts.css`

## Local Development
```bash
# Preview locally (any simple HTTP server works)
python3 -m http.server 8080
# Then open http://localhost:8080
```
No build step required — all files are static HTML/CSS/JS.

## Deployment
```bash
# SSH to server
ssh dora-website

# Full deploy (after git push)
ssh dora-website "cd /root/project/dora-agi.github.io && git pull origin main && \
  rsync -av --delete /root/project/dora-agi.github.io/ /var/www/dora-agi.github.io/ && \
  chown -R www-data:www-data /var/www/dora-agi.github.io/ && \
  chmod -R 755 /var/www/dora-agi.github.io/ && \
  nginx -t && systemctl reload nginx"

# Or use the server script
ssh dora-website "/root/scripts/update-website.sh"

# Verify
ssh dora-website "curl -s -o /dev/null -w '%{http_code}' https://doratech.cn"
```

## Server Details
- **SSH alias**: `dora-website` (115.190.184.245)
- **Web root**: `/var/www/dora-agi.github.io/`
- **Git repo on server**: `/root/project/dora-agi.github.io/`
- **Nginx config**: `/etc/nginx/sites-available/doratech.cn`
- **Maintenance guide**: Server `/root/project/MAINTENANCE_GUIDE.md`
- **Note**: SSH commands can be slow (~60s for git pull), use longer timeouts

## China Compatibility
- Google Fonts CDN: **Blocked** — all fonts self-hosted
- Google Analytics: **Blocked** — do not add
- External CDNs: Avoid when possible; prefer self-hosting assets
- ICP filing (备案) info displayed in footer — legally required
