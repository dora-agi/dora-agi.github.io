---
name: website-deployer
description: Deploy the doratech.cn website to production server via SSH. Use when the user asks to deploy, publish, update, or push the website to production, or mentions "dora-website", "doratech.cn deployment", or "上线/部署网站".
---

# Website Deployer

Deploy the dora-agi static website to the production Nginx server at doratech.cn.

## Quick Deploy

Run the bundled deploy script via SSH:

```bash
ssh dora-website 'bash -s' < scripts/deploy.sh
```

This performs: git pull → backup → rsync to web root → fix permissions → nginx reload → verify HTTP 200.

To skip backup (faster):

```bash
ssh dora-website 'bash -s' < scripts/deploy.sh -- --skip-backup
```

## Manual Deploy

If the script isn't available or needs adaptation:

```bash
ssh dora-website "cd /root/project/dora-agi.github.io && git pull origin main && \
  rsync -av --delete /root/project/dora-agi.github.io/ /var/www/dora-agi.github.io/ && \
  chown -R www-data:www-data /var/www/dora-agi.github.io/ && \
  chmod -R 755 /var/www/dora-agi.github.io/ && \
  nginx -t && systemctl reload nginx"
```

## Verify

```bash
ssh dora-website "curl -s -o /dev/null -w '%{http_code}' https://doratech.cn"
```

Check specific pages:

```bash
ssh dora-website "for p in / /terms.html /privacy.html /apps/dora.html; do \
  echo -n \"\$p: \"; curl -s -o /dev/null -w '%{http_code}' https://doratech.cn\$p; echo; done"
```

## Server Reference

| Item | Value |
|------|-------|
| SSH alias | `dora-website` |
| Server IP | 115.190.184.245 |
| Git repo | `/root/project/dora-agi.github.io/` |
| Web root | `/var/www/dora-agi.github.io/` |
| Nginx config | `/etc/nginx/sites-available/doratech.cn` |
| Update script | `/root/scripts/update-website.sh` |

## Gotchas

- SSH commands to this server can be slow (~60s for git pull). Use timeouts ≥60s.
- Always ensure code is pushed to `main` before deploying — the server pulls from `origin/main`.
- The rsync uses `--delete` — files removed from git will be removed from the server.
