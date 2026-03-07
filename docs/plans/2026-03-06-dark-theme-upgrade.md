# Dark Theme Upgrade Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform the DoraTech website from warm cream light theme to a Temporal.io-inspired dark theme with coral-to-lavender gradient accents.

**Architecture:** Pure CSS token + rule updates across 4 static HTML files. No JS changes needed. Each file has its own inline `<style>` block with duplicate design tokens — all must be updated consistently.

**Tech Stack:** Static HTML/CSS, Bootstrap 5, AOS.js, Font Awesome

---

### Task 1: Update `index.html` Design Tokens (`:root` block)

**Files:**
- Modify: `index.html:159-190` (`:root` CSS custom properties)

**Step 1: Replace the `:root` block**

Replace the existing `:root` variables (lines 160-190) with the dark theme tokens:

```css
:root {
    --bg-primary: #0D0F14;
    --bg-surface: #161922;
    --bg-elevated: #1C2030;
    --bg-card: #161922;
    --bg-cream: #0D0F14;
    --bg-warm: #161922;
    --bg-section: #1C2030;
    --text-primary: #F0F0F5;
    --text-secondary: #8B90A0;
    --text-muted: #555B6E;
    --accent-coral: #E8583A;
    --accent-coral-hover: #F06A4E;
    --accent-coral-light: rgba(232, 88, 58, 0.12);
    --accent-lavender: #7B6CB0;
    --accent-lavender-light: rgba(123, 108, 176, 0.12);
    --accent-sage: #5A9E6A;
    --accent-sage-light: rgba(90, 158, 106, 0.12);
    --accent-sky: #4A96C4;
    --accent-sky-light: rgba(74, 150, 196, 0.12);
    --accent-amber: #D4922A;
    --accent-amber-light: rgba(212, 146, 42, 0.12);
    --gradient-warm: linear-gradient(135deg, #E8583A 0%, #7B6CB0 100%);
    --gradient-soft: linear-gradient(135deg, rgba(232, 88, 58, 0.08), rgba(123, 108, 176, 0.08));
    --gradient-hero: linear-gradient(160deg, #0D0F14 0%, #161922 50%, #0D0F14 100%);
    --border-subtle: rgba(255, 255, 255, 0.06);
    --border-hover: rgba(255, 255, 255, 0.12);
    --shadow-soft: 0 2px 12px rgba(0, 0, 0, 0.3);
    --shadow-md: 0 4px 20px rgba(0, 0, 0, 0.4);
    --shadow-hover: 0 8px 32px rgba(0, 0, 0, 0.5);
    --shadow-card: 0 1px 8px rgba(0, 0, 0, 0.3);
    --shadow-glow: 0 0 40px rgba(232, 88, 58, 0.08);
    --radius-sm: 8px;
    --radius-md: 12px;
    --radius-lg: 16px;
    --radius-xl: 20px;
}
```

**Key principle:** We keep `--bg-cream` and `--bg-warm` variable names so existing CSS rules that reference them still work, but repoint them to dark colors.

**Step 2: Verify no build errors**

Run: `python3 -m http.server 8080` and open in browser.

**Step 3: Commit**

```bash
git add index.html
git commit -m "feat(website): update index.html design tokens to dark theme"
```

---

### Task 2: Update `index.html` Navigation & Base Styles

**Files:**
- Modify: `index.html:192-370` (body, grain overlay, headings, navbar CSS)

**Step 1: Update body background**

Body already uses `var(--bg-cream)` which now points to dark — no change needed.

**Step 2: Reduce grain overlay opacity**

Change `body::after` opacity from `0.025` to `0.015`.

**Step 3: Update navbar for dark theme**

Replace navbar background colors:
- `.navbar` background: `rgba(13, 15, 20, 0.85)` (was `rgba(250, 248, 245, 0.9)`)
- `.navbar.scrolled` background: `rgba(13, 15, 20, 0.96)` (was `rgba(250, 248, 245, 0.96)`)
- `.navbar` border-bottom: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.04)`)
- `.navbar.scrolled` box-shadow: `0 1px 0 rgba(255, 255, 255, 0.04)` (was `rgba(0, 0, 0, 0.06)`)
- `.navbar-toggler` border: `1px solid rgba(255, 255, 255, 0.1)` (was `rgba(0, 0, 0, 0.1)`)
- `.navbar-toggler:focus` border-color: `rgba(255, 255, 255, 0.2)` (was `rgba(0, 0, 0, 0.2)`)
- `.navbar-toggler-icon` SVG stroke: `rgba(240,240,245,0.6)` (was `rgba(26,26,26,0.6)`)

**Step 4: Update language selector for dark**

- `.language-selector .nav-link` border: `1px solid rgba(255, 255, 255, 0.1)` (was `rgba(0, 0, 0, 0.1)`)
- `.language-selector .nav-link:hover` border-color: `rgba(255, 255, 255, 0.2)`, background: `rgba(255, 255, 255, 0.03)` (was `rgba(0, 0, 0, 0.02)`)
- `.dropdown-menu` border: `1px solid var(--border-subtle)`, background: `var(--bg-surface)`, box-shadow: `0 8px 24px rgba(0, 0, 0, 0.4)` (was `rgba(0, 0, 0, 0.08)`)
- `.dropdown-item:hover` background: `rgba(255, 255, 255, 0.05)` (was `var(--bg-warm)`)

**Step 5: Update mobile nav for dark**

- `.navbar-collapse` background: `var(--bg-surface)` (was `var(--bg-card)`), border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.nav-link:hover, .nav-link.active` on mobile: background `rgba(255, 255, 255, 0.05)` (was `var(--bg-warm)`)

**Step 6: Commit**

```bash
git add index.html
git commit -m "feat(website): update index.html navigation to dark theme"
```

---

### Task 3: Update `index.html` Hero Section

**Files:**
- Modify: `index.html:389-498` (hero CSS)

**Step 1: Update hero dot grid pattern**

Change the `radial-gradient` dots from `rgba(0,0,0,0.04)` to `rgba(255,255,255,0.03)`.

**Step 2: Update hero accent glow**

Change the `::after` radial gradient from `rgba(232, 88, 58, 0.05)` to `rgba(232, 88, 58, 0.06)` (slightly stronger glow on dark).

**Step 3: Update hero accent text**

`.hero-content h1 .accent` — keep `color: var(--accent-coral)` (works on both themes since coral pops on dark).

**Step 4: Update preview card borders**

- `.preview-card` border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.preview-card:hover` box-shadow: add subtle glow `0 8px 32px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 255, 255, 0.08)`

**Step 5: Commit**

```bash
git add index.html
git commit -m "feat(website): update index.html hero section to dark theme"
```

---

### Task 4: Update `index.html` Buttons

**Files:**
- Modify: `index.html:534-570` (button CSS)

**Step 1: Update primary button to gradient**

`.btn-primary-warm`:
- `background: var(--gradient-warm)` (was `var(--text-primary)`)
- `color: white` (keep)
- hover: `background: linear-gradient(135deg, #F06A4E 0%, #8B7CC0 100%)`, `box-shadow: 0 4px 20px rgba(232, 88, 58, 0.25)` (glow effect)

**Step 2: Update outline button for dark**

`.btn-outline-warm`:
- `border: 1.5px solid rgba(255, 255, 255, 0.15)` (was `rgba(0, 0, 0, 0.15)`)
- `color: var(--text-primary)` (keep — now maps to white)
- hover: `border-color: rgba(255, 255, 255, 0.3)`, `background: rgba(255, 255, 255, 0.05)` (was `rgba(0, 0, 0, 0.02)`)

**Step 3: Commit**

```bash
git add index.html
git commit -m "feat(website): update index.html buttons to dark theme"
```

---

### Task 5: Update `index.html` Cards, About, Contact, Footer, Cookie

**Files:**
- Modify: `index.html:604-1060` (remaining component CSS)

**Step 1: Update app cards**

- `.app-card` border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.app-card:hover` add border-color: `var(--border-hover)` plus shadow-glow
- `.app-card-coming` border-color: `rgba(255, 255, 255, 0.06)` (was `rgba(0, 0, 0, 0.08)`)
- `.badge-coming` background: `rgba(255, 255, 255, 0.06)` (was `rgba(0, 0, 0, 0.04)`)
- Coming soon card icon placeholder inline styles (in HTML): change light backgrounds to dark equivalents

**Step 2: Update about section**

- `.about-stats` border-top: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)

**Step 3: Update contact section**

- `.contact-info-icon` background: `var(--bg-elevated)` (was `var(--bg-cream)`), border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.contact-form-card` border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.contact-info-content a` text-decoration-color: `rgba(255, 255, 255, 0.15)` (was `rgba(0, 0, 0, 0.15)`)
- `.warm-input` border: `1.5px solid rgba(255, 255, 255, 0.1)` (was `rgba(0, 0, 0, 0.1)`)
- `.warm-input:focus` border-color: `var(--accent-coral)` (was `var(--text-primary)`)
- `.btn-submit` background: `var(--gradient-warm)` (was `var(--text-primary)`), hover: glow shadow
- Autofill fix: `-webkit-box-shadow: 0 0 0px 1000px var(--bg-primary) inset` (was `var(--bg-cream)`)

**Step 4: Update footer**

Footer already uses dark background (`var(--text-primary)` = `#1A1A1A`). But now `--text-primary` = `#F0F0F5` (white). So we need to change footer to use explicit dark color:
- `footer` background: `var(--bg-surface)` (explicit dark surface instead of `var(--text-primary)`)
- `footer` border-top: `1px solid var(--border-subtle)`

**Step 5: Update cookie consent**

- `.cookie-consent` background: `var(--bg-surface)` (was `var(--bg-card)`), border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- `.btn-cookie-accept` background: `var(--gradient-warm)` (was `var(--text-primary)`)
- `.btn-cookie-reject` border: `1px solid rgba(255, 255, 255, 0.12)` (was `rgba(0, 0, 0, 0.12)`)
- `.btn-cookie-reject:hover` border-color: `rgba(255, 255, 255, 0.25)` (was `rgba(0, 0, 0, 0.25)`)

**Step 6: Commit**

```bash
git add index.html
git commit -m "feat(website): update index.html cards, about, contact, footer to dark theme"
```

---

### Task 6: Update `index.html` HTML Inline Styles & Meta Tags

**Files:**
- Modify: `index.html:60` (`theme-color` meta)
- Modify: `index.html:1214,1237,1296,1316` (inline `style` attributes on coming-soon cards)

**Step 1: Update theme-color meta**

Change `<meta name="theme-color" content="#FAF8F5">` to `<meta name="theme-color" content="#0D0F14">`.

**Step 2: Update inline style backgrounds on coming-soon placeholders**

The coming-soon card icon placeholders use inline `style="background: var(--accent-sage-light);"` and `style="background: var(--accent-sky-light);"`. Since we updated `--accent-sage-light` and `--accent-sky-light` tokens to use `rgba()` on dark, these inline styles will automatically pick up the dark values. No HTML change needed.

**Step 3: Also update the `h3` inline styles**

Lines with `style="color: var(--text-muted);"` — these use the CSS variable and will automatically inherit the new muted color. No change needed.

**Step 4: Commit** (only if meta tag changed)

```bash
git add index.html
git commit -m "feat(website): update index.html theme-color meta for dark theme"
```

---

### Task 7: Update `apps/dora.html` for Dark Theme

**Files:**
- Modify: `apps/dora.html:52` (`theme-color` meta)
- Modify: `apps/dora.html:87-500+` (CSS `:root` and all component styles)

**Step 1: Update `:root` tokens** (lines 89-120)

Same token values as Task 1, adapted for dora.html's existing variables.

**Step 2: Update grain overlay**

Same as Task 2 — opacity `0.015`.

**Step 3: Update navbar**

Same dark background pattern as Task 2.

**Step 4: Update hero section**

- `.hero` dot grid: `rgba(255,255,255,0.03)` (was `rgba(0,0,0,0.04)`)
- `.hero::after` radial gradient: lavender glow `rgba(123, 108, 176, 0.06)` (was `0.04`)
- `.hero h1 .text-gradient` — keep lavender, it pops on dark already

**Step 5: Update buttons**

Same gradient pattern as Task 4.

**Step 6: Update phone mockup**

- `.phone-frame` border: `2px solid rgba(255, 255, 255, 0.08)` (was `rgba(0, 0, 0, 0.08)`)
- `.phone-frame .phone-placeholder` background: `var(--bg-elevated)` (was `var(--bg-warm)`)

**Step 7: Update feature cards**

- `.feature-card` border: `1px solid var(--border-subtle)` (was `rgba(0, 0, 0, 0.06)`)
- Feature icon backgrounds: keep using `--accent-*-light` tokens (already updated)

**Step 8: Update other sections** (screenshots, CTA, footer, cookie)

Apply same dark patterns. Footer needs explicit `background: var(--bg-surface)`.

**Step 9: Update theme-color meta**

Change `#FAF8F5` to `#0D0F14`.

**Step 10: Commit**

```bash
git add apps/dora.html
git commit -m "feat(website): update apps/dora.html to dark theme"
```

---

### Task 8: Update `privacy.html` for Dark Theme

**Files:**
- Modify: `privacy.html:21-203` (CSS block)

**Step 1: Update `:root` tokens** (lines 22-36)

```css
:root {
    --bg-cream: #0D0F14;
    --bg-warm: #161922;
    --bg-card: #161922;
    --text-primary: #F0F0F5;
    --text-secondary: #8B90A0;
    --text-muted: #555B6E;
    --accent-coral: #E8583A;
    --accent-coral-light: rgba(232, 88, 58, 0.12);
    --accent-lavender: #7B6CB0;
    --accent-lavender-light: rgba(123, 108, 176, 0.12);
    --shadow-soft: 0 2px 12px rgba(0, 0, 0, 0.3);
    --radius-sm: 8px;
    --radius-md: 12px;
}
```

**Step 2: Update navbar**

- `.navbar` background: `rgba(13, 15, 20, 0.96)` (was `rgba(250, 248, 245, 0.96)`)
- border-bottom: `1px solid rgba(255, 255, 255, 0.06)` (was `rgba(0, 0, 0, 0.04)`)
- box-shadow: `0 1px 0 rgba(255, 255, 255, 0.04)` (was `rgba(0, 0, 0, 0.06)`)

**Step 3: Update h2 border-bottom**

`border-bottom: 1px solid rgba(232, 88, 58, 0.2)` (same, works on dark)

**Step 4: Update table styles**

- `th, td` border: `1px solid rgba(255, 255, 255, 0.06)` (was `rgba(45, 42, 50, 0.08)`)
- `th` background: `rgba(232, 88, 58, 0.12)` (was `var(--accent-coral-light)` — same now)
- `td` background: `var(--bg-card)` (same)

**Step 5: Update contact-box**

- border: `1px solid rgba(255, 255, 255, 0.06)` (was `rgba(45, 42, 50, 0.08)`)

**Step 6: Update footer**

- `footer` background: `#161922` (was `#2D2A32`)

**Step 7: Update back-link**

Keep coral color — works on dark.

**Step 8: Update hr**

- `border-color: rgba(255, 255, 255, 0.08)` (was `rgba(45, 42, 50, 0.1)`)

**Step 9: Update bottom company text**

Line 519: change `color: rgba(230, 244, 241, 0.6)` — this already works on dark but adjust to `color: var(--text-muted)` for consistency.

**Step 10: Commit**

```bash
git add privacy.html
git commit -m "feat(website): update privacy.html to dark theme"
```

---

### Task 9: Update `terms.html` for Dark Theme

**Files:**
- Modify: `terms.html:21-205` (CSS block)

**Step 1: Apply same `:root` token updates** as Task 8, plus `--accent-amber` tokens:

```css
--accent-amber: #D4922A;
--accent-amber-light: rgba(212, 146, 42, 0.12);
```

**Step 2: Update navbar** — same as Task 8.

**Step 3: Update warning-box**

- `.warning-box` background: `rgba(123, 108, 176, 0.1)` (was `var(--accent-lavender-light)` — same now with updated token)
- border: `1px solid rgba(123, 108, 176, 0.2)` (keep — works on dark)
- `.warning-box p, .warning-box li` color: `var(--text-primary)` (keep)

**Step 4: Update caps-warning**

- `.caps-warning` background: `rgba(212, 146, 42, 0.1)` (was `var(--accent-amber-light)`)
- border: `1px solid rgba(212, 146, 42, 0.25)` (was `rgba(245, 166, 35, 0.3)`)

**Step 5: Apply same table, contact-box, footer, hr, and bottom-text updates** as Task 8.

**Step 6: Commit**

```bash
git add terms.html
git commit -m "feat(website): update terms.html to dark theme"
```

---

### Task 10: Visual Verification & Fix-up

**Files:**
- All 4 HTML files

**Step 1: Start local server**

```bash
cd /Users/wizhang/Workspace/WickyProjects/dora/website/dora-agi-website
python3 -m http.server 8080
```

**Step 2: Check each page visually**

Open in browser and verify:
- `http://localhost:8080/` — index.html
- `http://localhost:8080/apps/dora.html` — dora app page
- `http://localhost:8080/privacy.html` — privacy page
- `http://localhost:8080/terms.html` — terms page

Check for:
- No white flashes or unthemed areas
- Text is readable on dark background
- Buttons have gradient accent
- Cards have subtle borders
- Footer looks consistent
- Cookie consent popup themed

**Step 3: Fix any remaining contrast or visibility issues**

Look for hardcoded colors in inline styles that need updating.

**Step 4: Final commit**

```bash
git add .
git commit -m "fix(website): address visual issues from dark theme migration"
```
