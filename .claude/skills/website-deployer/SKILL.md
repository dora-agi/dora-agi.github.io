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

This performs: git pull → backup → rsync to web root (excluding `.git/`, `CLAUDE.md`, `.claude/`, `docs/`, etc. via `.deploy-exclude`) → cleanup leftovers → fix permissions → nginx reload → verify HTTP 200.

To skip backup (faster):

```bash
ssh dora-website 'bash -s' < scripts/deploy.sh -- --skip-backup
```

## Alternative: Server-side Script

The server also has an equivalent script at `/root/scripts/update-website.sh`:

```bash
ssh dora-website "/root/scripts/update-website.sh"
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

## Security

- **Sensitive files are excluded** from rsync via `.deploy-exclude` in repo root
- **Nginx blocks** dotfiles (`/.git/`, `/.claude/`), `CLAUDE.md`, `README.md`, and `/docs/` with 404
- The deploy script also **cleans up leftover sensitive files** from previous deploys
- If adding new internal files to the repo, add them to `.deploy-exclude`

## Gotchas

- SSH commands to this server can be slow (~60s for git pull). Use timeouts ≥60s.
- Always ensure code is pushed to `main` before deploying — the server pulls from `origin/main`.
- The rsync uses `--delete` — files removed from git will be removed from the server (except excluded files).
