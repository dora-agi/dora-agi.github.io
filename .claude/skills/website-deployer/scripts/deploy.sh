#!/bin/bash
# Deploy dora-agi website to production server
# Usage: ssh dora-website 'bash -s' < deploy.sh
#   or:  ssh dora-website 'bash -s' < deploy.sh -- --skip-backup

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
echo "[1/5] Pulling latest code..."
cd "$REPO_DIR"
git pull origin main

# 2. Backup (optional)
if [ "$SKIP_BACKUP" = false ]; then
  BACKUP_DIR="/var/backups/dora-agi/$(date +%Y%m%d_%H%M%S)"
  echo "[2/5] Backing up to $BACKUP_DIR..."
  mkdir -p "$BACKUP_DIR"
  cp -r "$WEB_DIR" "$BACKUP_DIR/"
else
  echo "[2/5] Skipping backup"
fi

# 3. Sync files
echo "[3/5] Syncing to web directory..."
rsync -av --delete "$REPO_DIR/" "$WEB_DIR/"

# 4. Fix permissions
echo "[4/5] Setting permissions..."
chown -R www-data:www-data "$WEB_DIR"
chmod -R 755 "$WEB_DIR"

# 5. Reload nginx
echo "[5/5] Reloading nginx..."
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
