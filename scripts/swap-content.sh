#!/bin/bash
# Swap between review-safe and full astrology website content
# Usage: ./scripts/swap-content.sh [review|astro]

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

case "$1" in
  review)
    echo "Switching to REVIEW-SAFE version (no astrology terms)..."
    cp "$SITE_DIR/apps/dora.html" "$SITE_DIR/apps/dora-astro.html"
    cp "$SITE_DIR/index.html" "$SITE_DIR/index-astro.html"
    # dora.html and index.html are already the review versions
    echo "Done. Current live version: REVIEW-SAFE"
    ;;
  astro)
    echo "Switching to FULL ASTROLOGY version..."
    if [ ! -f "$SITE_DIR/apps/dora-astro.html" ]; then
      echo "ERROR: dora-astro.html not found. Cannot switch."
      exit 1
    fi
    cp "$SITE_DIR/apps/dora-astro.html" "$SITE_DIR/apps/dora.html"
    cp "$SITE_DIR/index-astro.html" "$SITE_DIR/index.html"
    echo "Done. Current live version: FULL ASTROLOGY"
    ;;
  status)
    if grep -q "AI Astrologer" "$SITE_DIR/apps/dora.html" 2>/dev/null; then
      echo "Current: FULL ASTROLOGY"
    else
      echo "Current: REVIEW-SAFE"
    fi
    ;;
  *)
    echo "Usage: $0 [review|astro|status]"
    echo ""
    echo "  review  — Switch to review-safe content (no astrology/fortune terms)"
    echo "  astro   — Switch to full astrology content"
    echo "  status  — Show which version is currently live"
    exit 1
    ;;
esac
