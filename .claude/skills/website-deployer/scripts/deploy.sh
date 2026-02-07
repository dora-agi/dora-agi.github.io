#!/bin/bash
# Deploy dora-agi website to production server
# Usage: ssh dora-website 'bash -s' < deploy.sh
#   or:  ssh dora-website 'bash -s' < deploy.sh -- --skip-backup
#
# This script:
#   1. Pulls latest code from git
#   2. Optionally backs up current web root
#   3. Syncs ONLY web-safe files (excludes .git, CLAUDE.md, .claude/, docs/, etc.)
#   4. Fixes permissions
#   5. Reloads nginx and verifies

set -euo pipefail

REPO_DIR="/root/project/dora-agi.github.io"
WEB_DIR="/var/www/dora-agi.github.io"
SKIP_BACKUP=false

for arg in "$@"; do
  case $arg in
    --skip-backup) SKIP_BACKUP=true ;;
  esac
done

echo "=== Deploying doratech.cn ==="

# 1. Pull latest code
echo "[1/6] Pulling latest code..."
cd "$REPO_DIR"
git pull origin main

# 2. Backup (optional)
if [ "$SKIP_BACKUP" = false ]; then
  BACKUP_DIR="/var/backups/dora-agi/$(date +%Y%m%d_%H%M%S)"
  echo "[2/6] Backing up to $BACKUP_DIR..."
  mkdir -p "$BACKUP_DIR"
  cp -r "$WEB_DIR" "$BACKUP_DIR/"
else
  echo "[2/6] Skipping backup"
fi

# 3. Sync files — exclude sensitive/internal files
echo "[3/6] Syncing to web directory (with exclusions)..."
EXCLUDE_FILE="$REPO_DIR/.deploy-exclude"
if [ -f "$EXCLUDE_FILE" ]; then
  rsync -av --delete --exclude-from="$EXCLUDE_FILE" "$REPO_DIR/" "$WEB_DIR/"
else
  # Fallback: inline exclusions if .deploy-exclude is missing
  rsync -av --delete \
    --exclude='.git/' \
    --exclude='.gitignore' \
    --exclude='.claude/' \
    --exclude='CLAUDE.md' \
    --exclude='docs/' \
    --exclude='README.md' \
    --exclude='CNAME' \
    --exclude='.DS_Store' \
    --exclude='.deploy-exclude' \
    "$REPO_DIR/" "$WEB_DIR/"
fi

# 4. Clean up leftover sensitive files from previous deploys
echo "[4/6] Cleaning up any leftover sensitive files..."
rm -rf "$WEB_DIR/.git" "$WEB_DIR/.claude" "$WEB_DIR/docs"
rm -f "$WEB_DIR/CLAUDE.md" "$WEB_DIR/README.md" "$WEB_DIR/.gitignore" "$WEB_DIR/CNAME"

# 5. Fix permissions
echo "[5/6] Setting permissions..."
chown -R www-data:www-data "$WEB_DIR"
chmod -R 755 "$WEB_DIR"

# 6. Reload nginx
echo "[6/6] Reloading nginx..."
nginx -t
systemctl reload nginx

# Verify
STATUS=$(curl -s -o /dev/null -w '%{http_code}' https://doratech.cn)
if [ "$STATUS" = "200" ]; then
  echo "=== Deploy successful (HTTP $STATUS) ==="
else
  echo "=== WARNING: Site returned HTTP $STATUS ==="
  exit 1
fi
