# DoraTech Website Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Redesign the DoraTech official website from a dark neon theme to a warm, friendly "Creative App Studio" style, with a multi-app architecture for future expansion.

**Architecture:** Single-page main site (`index.html`) with separate app detail pages (`apps/dora.html`). All CSS is inline in each HTML file (matching existing pattern). Bootstrap 5 + AOS animation library retained. Google Fonts loaded for typography (Plus Jakarta Sans + Inter). Language switcher (EN/ZH) preserved.

**Tech Stack:** HTML5, CSS3 (inline `<style>`), Bootstrap 5 (local), AOS.js (local), Font Awesome (local), Google Fonts (CDN), Formspree (contact form)

---

### Task 1: Redesign index.html — Complete Rewrite

**Files:**
- Modify: `index.html` (full rewrite, preserving SEO meta, structured data, GA, Formspree, language switching JS)

**Overview:** Replace the entire index.html with the new warm design. This is one large task because the HTML and CSS are tightly coupled in one file.

**Design System (CSS Variables):**
```css
:root {
    --bg-cream: #FEFAF6;
    --bg-warm: #FFF8F0;
    --bg-card: #FFFFFF;
    --text-primary: #2D2A32;
    --text-secondary: #6B6672;
    --text-muted: #9B95A3;
    --accent-coral: #FF6B4A;
    --accent-coral-light: #FFF0ED;
    --accent-lavender: #8B7EC8;
    --accent-lavender-light: #F3F0FF;
    --accent-sage: #7BB88A;
    --accent-sage-light: #EDF7EF;
    --accent-sky: #5AAFDE;
    --accent-sky-light: #EBF5FC;
    --gradient-warm: linear-gradient(135deg, #FF6B4A, #8B7EC8);
    --gradient-soft: linear-gradient(135deg, #FFF0ED, #F3F0FF);
    --shadow-soft: 0 4px 24px rgba(45, 42, 50, 0.08);
    --shadow-hover: 0 8px 32px rgba(45, 42, 50, 0.12);
    --radius-sm: 12px;
    --radius-md: 16px;
    --radius-lg: 24px;
    --radius-xl: 32px;
}
```

**Typography:**
- Headings: 'Plus Jakarta Sans', sans-serif (loaded from Google Fonts)
- Body: 'Inter', sans-serif (loaded from Google Fonts)
- Chinese fallback: 'PingFang SC', 'Microsoft YaHei', sans-serif

**Page Structure:**

1. **Navigation** — White/cream background, subtle shadow on scroll, DoraTech logo + text brand, nav items: Apps (dropdown for future), About, Contact, Language toggle
2. **Hero Section** — Cream background, left-aligned text with tagline "AI-powered experiences, human at heart" / "用AI创造有温度的体验", right side shows floating app cards preview, warm gradient accent blob in background
3. **Apps Showcase Section** — Grid of app cards, each card has: app icon placeholder, app name, one-liner, personality color, "Learn More" link. Currently one card for Dora (with lavender accent). Include 2 "Coming Soon" ghost cards for future apps.
4. **About Section** — Two-column: team image + company story text
5. **Contact Section** — Warm card with Formspree form + contact info
6. **Footer** — Cream-tinted dark footer with ICP/公安备案 links, privacy/terms links

**Preserved from existing:**
- All SEO meta tags and structured data (JSON-LD)
- Google Analytics conditional loading
- Formspree form action and validation JS
- Language switching system (localStorage + `lang-zh`/`lang-en` classes)
- AOS animation initialization
- Cookie consent banner
- Bootstrap and AOS local resources
- Year auto-update script

**Step 1:** Write the complete new `index.html` with all sections above.

**Step 2:** Verify by opening in browser:
```bash
open index.html
```
Expected: Warm cream-themed page with all sections visible, responsive on mobile.

**Step 3:** Commit
```bash
git add index.html
git commit -m "feat: redesign website with warm creative studio theme"
```

---

### Task 2: Create Dora App Detail Page

**Files:**
- Create: `apps/dora.html`

**Overview:** Dedicated detail page for the Dora app with full feature showcase.

**Page Structure:**
1. **Navigation** — Same as main page but with "Back to Home" link
2. **Hero** — App name + tagline + phone mockup with screenshot placeholder + download buttons (App Store / Google Play placeholders)
3. **Features Section** — 4 feature cards with icons:
   - AI Astrology Insights
   - Emotional Healing
   - 24/7 Companion
   - Natal Chart Analysis
4. **Screenshot Gallery** — Placeholder images for future app screenshots
5. **Download CTA** — Final call-to-action with download buttons
6. **Footer** — Same as main page

**Style:** Uses Dora's personality color (lavender `#8B7EC8`) as accent throughout the page while maintaining the warm base theme.

**Step 1:** Create `apps/` directory and write `apps/dora.html`.

**Step 2:** Verify by opening in browser:
```bash
open apps/dora.html
```
Expected: Warm-themed app detail page with lavender accent, responsive.

**Step 3:** Update the "Learn More" / "Explore Dora" link in `index.html` to point to `apps/dora.html`.

**Step 4:** Commit
```bash
git add apps/dora.html index.html
git commit -m "feat: add Dora app detail page"
```

---

### Task 3: Update Privacy and Terms Pages Styling

**Files:**
- Modify: `privacy.html`
- Modify: `terms.html`

**Overview:** Update the styling of legal pages to match the new warm theme. Keep all content unchanged — only update CSS variables and visual styles.

**Step 1:** Read both files and update their inline CSS to use the new warm color scheme.

**Step 2:** Verify both pages look consistent with the new design.

**Step 3:** Commit
```bash
git add privacy.html terms.html
git commit -m "style: update legal pages to match new warm theme"
```

---

### Task 4: Update sitemap.xml

**Files:**
- Modify: `sitemap.xml`

**Overview:** Add the new `apps/dora.html` page to the sitemap.

**Step 1:** Add entry for `https://doratech.site/apps/dora.html`.

**Step 2:** Commit
```bash
git add sitemap.xml
git commit -m "chore: add dora app page to sitemap"
```

---

## Asset Placeholders

The following placeholders are used and should be replaced with real assets:

| Placeholder | Description | Location |
|------------|-------------|----------|
| `resources/dora_logo.jpg` | Company logo | Nav bar, footer |
| `resources/dora.jpg` | Dora app screenshot | App card, detail page |
| `resources/dora-icon.png` | Dora app icon (rounded square) | App showcase card |
| `resources/team.jpg` | Team photo | About section |
| App Store / Google Play links | Download URLs | Dora detail page |

## Execution Notes

- The main `index.html` is a complete rewrite (~2500 lines). All logic (language switching, form handling, GA, cookie consent) is preserved.
- No new CSS/JS files are created — everything stays inline to match the existing single-file pattern.
- The design uses SVG decorative blobs and CSS gradients instead of background images for the warm aesthetic.
- Each future app can have its own detail page following the `apps/dora.html` template.
- "Coming Soon" cards in the apps grid provide visual space for future products.
