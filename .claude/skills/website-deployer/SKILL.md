---
name: website-deployer
description: Deploy the doratech.cn website to production server via SSH. Use when the user asks to deploy, publish, update, or push the website to production, or mentions "dora-website", "doratech.cn deployment", or "上线/部署网站".
---

# Website Deployer

Deploy the dora-agi static website to the production Nginx server at doratech.cn.

## Deploy Procedure

Follow these steps **in order**:

### Step 1: Check for unpushed commits

```bash
git status
git log origin/main..HEAD --oneline
```

If there are unpushed commits, proceed to Step 2. If already up to date, skip to Step 3.

### Step 2: Push to origin (requires SSH passphrase)

The SSH key at `~/.ssh/id_rsa` is passphrase-protected. Ask the user for their passphrase using AskUserQuestion:

```
"What is your SSH key passphrase for git push?"
```

Then use it in-memory only — **NEVER write the passphrase to any file, log, script, or memory**:

```bash
eval "$(ssh-agent -s)" && \
  ASKPASS_SCRIPT=$(mktemp) && \
  echo '#!/bin/sh' > "$ASKPASS_SCRIPT" && \
  echo 'echo "USER_PASSPHRASE_HERE"' >> "$ASKPASS_SCRIPT" && \
  chmod +x "$ASKPASS_SCRIPT" && \
  SSH_ASKPASS="$ASKPASS_SCRIPT" SSH_ASKPASS_REQUIRE=force ssh-add ~/.ssh/id_rsa </dev/null 2>&1 && \
  rm -f "$ASKPASS_SCRIPT" && \
  git push 2>&1; \
  ssh-agent -k > /dev/null 2>&1
```

The temp file and ssh-agent are destroyed immediately after push. Verify the push succeeded before continuing.

### Step 3: Deploy to server

```bash
ssh dora-website 'bash -s' < .claude/skills/website-deployer/scripts/deploy.sh -- --skip-backup
```

This performs: git pull → version.json → rsync to web root (excluding sensitive files) → cleanup → permissions → nginx reload → verify HTTP 200.

Use `timeout: 120000` for this command (server can be slow).

For a full backup deploy (slower), omit `--skip-backup`.

### Step 4: Verify

The deploy script verifies automatically. For additional checks:

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

- **SSH passphrase**: Asked at deploy time, used in-memory only. NEVER persist to disk, logs, or memory files.
- **Sensitive files are excluded** from rsync via `.deploy-exclude` in repo root
- **Nginx blocks** dotfiles (`/.git/`, `/.claude/`), `CLAUDE.md`, `README.md`, and `/docs/` with 404
- The deploy script also **cleans up leftover sensitive files** from previous deploys
- If adding new internal files to the repo, add them to `.deploy-exclude`

## Gotchas

- SSH commands to this server can be slow (~60s for git pull). Use timeouts >= 60s.
- Always push to `main` before deploying — the server pulls from `origin/main`.
- The rsync uses `--delete` — files removed from git will be removed from the server.
