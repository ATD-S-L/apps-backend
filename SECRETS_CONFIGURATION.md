# GitHub Secrets Configuration Guide

**Status**: Ready for manual configuration  
**Updated**: November 12, 2026  
**Scope**: ATD-S-L Organization Level

---

## Overview

This guide provides step-by-step instructions to configure GitHub secrets at the **organization level**. These secrets will be available to all repositories under ATD-S-L and enable critical automation workflows.

### Why Organization-Level Secrets?
- Single configuration point for all 4 repositories
- Easier secret rotation and management
- Consistent across all projects
- Reduced maintenance overhead

---

## Access Organization Settings

1. Go to: https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Ensure you have **Organization Owner** or **Admin** role
3. You should see: **"Actions secrets"** section

---

## Required Secrets Configuration

### 🔴 TIER 1: CRITICAL (Required for Deployment)

#### 1. NPM_TOKEN

**Purpose**: Enable core-libraries automatic publishing to npm registry

**Step-by-Step**:
1. Go to https://www.npmjs.com/ → Sign in to your account
2. Click your **avatar** → **Access Tokens**
3. Click **Generate New Token**
4. Select type: **Automation**
5. Name it: `ci-cd-github-actions`
6. Click **Generate token**
7. **Copy the token immediately** (won't be shown again)

**In GitHub**:
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Click **New organization secret**
3. Name: `NPM_TOKEN`
4. Value: [paste the token from npm]
5. Repository access: Select **All repositories** (or specific ones)
6. Click **Add secret**

**Verification**:
```bash
# After configuration, push a commit to core-libraries
git push origin main

# Check GitHub Actions → core-libraries → deploy workflow
# Should complete successfully with "Published to npm"
```

---

#### 2. SONAR_PROJECT_KEY

**Purpose**: Identify project in SonarQube for code quality scanning

**Step-by-Step**:
1. Log into your **SonarQube instance** (or create at https://www.sonarcloud.io for free)
2. Click **Projects** in top menu
3. Create new project or use existing
4. Note the **Project Key** (e.g., `ATD-S-L:apps-backend`)
   - Format is usually: `organization:project-name`

**In GitHub**:
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Click **New organization secret**
3. Name: `SONAR_PROJECT_KEY`
4. Value: [your SonarQube project key]
5. Repository access: **All repositories**
6. Click **Add secret**

**Get it from SonarQube**:
- Navigate to project settings
- Project Key is displayed in the overview

---

#### 3. SONAR_TOKEN

**Purpose**: Authenticate with SonarQube for code analysis

**Step-by-Step**:
1. Log into your **SonarQube instance**
2. Click your **avatar** (top-right) → **My Account**
3. Click **Security** tab
4. Under **Tokens**, click **Generate Tokens**
5. Name: `github-actions-ci`
6. Type: Select **Global Analysis Token**
7. Click **Generate**
8. **Copy the token immediately** (won't be shown again)

**In GitHub**:
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Click **New organization secret**
3. Name: `SONAR_TOKEN`
4. Value: [paste SonarQube token]
5. Repository access: **All repositories**
6. Click **Add secret**

**Note**: If using SonarCloud.io:
- Same steps, but at https://sonarcloud.io/account/security

---

### 🟡 TIER 2: RECOMMENDED (Enhanced Notifications)

#### 4. SLACK_WEBHOOK_URL

**Purpose**: Send workflow notifications to Slack channel

**Step-by-Step**:
1. Go to https://api.slack.com/apps
2. Click **Create New App** → **From scratch**
3. Enter name: `GitHub Workflows`
4. Select workspace
5. In left menu, click **Incoming Webhooks**
6. Toggle **Activate Incoming Webhooks** to **On**
7. Click **Add New Webhook to Workspace**
8. Select channel: (e.g., `#deployments` or `#ci-notifications`)
9. Click **Authorize**
10. **Copy the Webhook URL** (starts with `https://hooks.slack.com/services/...`)

**Test the webhook**:
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"✅ GitHub Actions test message"}' \
  https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```
You should see the message appear in your Slack channel.

**In GitHub**:
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Click **New organization secret**
3. Name: `SLACK_WEBHOOK_URL`
4. Value: [paste the Webhook URL]
5. Repository access: **All repositories**
6. Click **Add secret**

**Verification**: 
- Trigger a workflow in any repo
- Should see notification in Slack channel

---

#### 5. DISCORD_WEBHOOK_URL (Optional Alternative)

**Purpose**: Discord notifications instead of or alongside Slack

**Step-by-Step**:
1. Open **Discord Server** where you want notifications
2. Right-click channel name → **Edit Channel**
3. Go to **Integrations** → **Webhooks**
4. Click **Create Webhook**
5. Give it a name: `GitHub Workflows`
6. Copy the **Webhook URL**

**Test the webhook**:
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"content":"✅ GitHub Actions test message"}' \
  https://discord.com/api/webhooks/YOUR/WEBHOOK/URL
```

**In GitHub**:
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Click **New organization secret**
3. Name: `DISCORD_WEBHOOK_URL`
4. Value: [paste the Webhook URL]
5. Repository access: **All repositories**
6. Click **Add secret**

---

### 🔵 TIER 3: OPTIONAL (Advanced Features)

#### 6. LIGHTHOUSE_CI_GITHUB_TOKEN

**Purpose**: Lighthouse performance monitoring for apps-frontend

**Step-by-Step**:
1. Go to https://github.com/settings/tokens
2. Click **Generate new token** → **Generate new token (classic)**
3. Name: `lighthouse-ci-token`
4. Select scopes:
   - ✅ `repo` (full control of private repositories)
   - ✅ `write:packages` (upload packages to GitHub Package Registry)
5. Click **Generate token**
6. **Copy the token immediately**

**In GitHub** (apps-frontend repository only):
1. Go to: https://github.com/ATD-S-L/apps-frontend/settings/secrets/actions
2. Click **New repository secret**
3. Name: `LIGHTHOUSE_CI_GITHUB_TOKEN`
4. Value: [paste GitHub token]
5. Click **Add secret**

---

#### 7. DOCKER_USERNAME & DOCKER_PASSWORD

**Purpose**: Docker Hub authentication for image pushes (if using Docker)

**Step-by-Step**:
1. Create account at https://hub.docker.com or sign in
2. Click your **avatar** → **Account Settings**
3. Click **Security** → **New Access Token**
4. Name: `github-actions`
5. Permissions: Select **Read & Write**
6. Click **Generate**
7. **Copy the token**

**In GitHub** (organization level):
1. At https://github.com/organizations/ATD-S-L/settings/secrets/actions
2. Create two secrets:
   - Name: `DOCKER_USERNAME`, Value: [your Docker username]
   - Name: `DOCKER_PASSWORD`, Value: [the access token]
3. Repository access: **All repositories**

---

#### 8. SNYK_TOKEN

**Purpose**: Advanced security vulnerability scanning for firmware-esp32

**Step-by-Step**:
1. Go to https://app.snyk.io/ → Sign up (free tier available)
2. Click your **avatar** → **Account settings**
3. Look for **API Token** section
4. Click **Show** and copy the token

**In GitHub** (firmware-esp32 repository only):
1. Go to: https://github.com/ATD-S-L/firmware-esp32/settings/secrets/actions
2. Click **New repository secret**
3. Name: `SNYK_TOKEN`
4. Value: [paste Snyk token]
5. Click **Add secret**

---

## Secrets Verification Checklist

After configuring secrets, verify they're working:

### For all repos
- [ ] Push a commit to main
- [ ] GitHub Actions workflows trigger automatically
- [ ] Check Actions tab for successful runs
- [ ] Review workflow logs for errors

### For core-libraries (NPM_TOKEN)
```bash
# Trigger deploy workflow
git tag v0.0.1 && git push origin v0.0.1
# Check: Package published to https://www.npmjs.com/package/@atd-sl/core-libraries
```

### For notifications (SLACK_WEBHOOK_URL)
- [ ] Check Slack channel receives workflow notifications
- [ ] Verify message content is readable
- [ ] Test with failed workflow to see error notifications

### For SonarQube (SONAR_TOKEN + SONAR_PROJECT_KEY)
- [ ] Trigger build workflow
- [ ] Check SonarQube dashboard for new scan results
- [ ] Verify code quality metrics appear

---

## Troubleshooting

### Secret Not Found in Workflow
```
Error: Unrecognized named-value: 'secrets.NPM_TOKEN'
```
**Solution**:
1. Verify secret exists in GitHub organization settings
2. Check exact spelling (case-sensitive)
3. Ensure secret is set to **Organization level** (not repository)
4. If repository-specific, verify it's in that repo's settings

### "Invalid Token" Error
```
Error: 401 Unauthorized - Invalid credentials
```
**Solution**:
1. Verify token is still valid (check provider)
2. Check token hasn't expired (regenerate if needed)
3. Verify token has correct permissions/scopes
4. For npm: confirm it's "Automation" type, not "Read-only"

### Workflow Still Fails After Adding Secret
```
Error: npm ERR! code E401
```
**Solution**:
1. Wait 1-2 minutes for GitHub to propagate the secret
2. Manually re-run the workflow from Actions tab
3. Check secret value was pasted correctly (no extra spaces)
4. View workflow logs to see which step is failing

### Slack Notifications Not Appearing
```
No message in Slack channel after workflow completes
```
**Solution**:
1. Test webhook manually: `curl -X POST ... YOUR_WEBHOOK_URL`
2. Verify webhook URL format (should start with `https://hooks.slack.com/`)
3. Check Slack channel is active and notifications enabled
4. Review workflow logs for notification step errors
5. Confirm `SLACK_WEBHOOK_URL` is set as **Secret**, not Variable

---

## Security Best Practices

### ✅ DO's
- ✅ Use **Secret** scope for sensitive tokens (auto-masked in logs)
- ✅ Use **Variable** scope only for non-sensitive config (URLs, etc.)
- ✅ Rotate tokens every 90 days
- ✅ Use dedicated service accounts (not personal accounts)
- ✅ Limit token permissions to minimum required
- ✅ Enable 2FA on npm/GitHub/SonarQube accounts
- ✅ Audit secret access in GitHub logs regularly
- ✅ Delete unused tokens immediately

### ❌ DON'Ts
- ❌ Never commit secrets to git (even in private repos)
- ❌ Never paste secrets in Slack/email/chat
- ❌ Never use personal access tokens (use automation tokens)
- ❌ Never grant more permissions than needed
- ❌ Never log or print secrets in workflow output
- ❌ Never reuse same token across multiple services
- ❌ Never share GitHub secrets URL with unauthorized users

---

## Secret Rotation Schedule

### Recommended Rotation
| Secret | Rotation Frequency | Next Review |
|--------|-------------------|-------------|
| NPM_TOKEN | 90 days | February 12, 2027 |
| SONAR_TOKEN | 90 days | February 12, 2027 |
| SLACK_WEBHOOK_URL | 180 days | May 12, 2027 |
| DOCKER credentials | 90 days | February 12, 2027 |

### How to Rotate
1. Generate new token at provider (npm, SonarQube, etc.)
2. Update secret value in GitHub Settings
3. Test by running workflow
4. Revoke old token at provider
5. Log rotation in team documentation

---

## Support & Resources

| Topic | Link |
|-------|------|
| GitHub Secrets Docs | https://docs.github.com/en/actions/security-guides/encrypted-secrets |
| npm Access Tokens | https://docs.npmjs.com/creating-and-viewing-authentication-tokens |
| Slack Webhooks | https://api.slack.com/messaging/webhooks |
| SonarQube Tokens | https://docs.sonarqube.org/latest/user-guide/user-token/ |
| Docker Access Tokens | https://docs.docker.com/docker-hub/access-tokens/ |

---

## Next Steps

After configuring all secrets:

1. ✅ Verify each secret in workflow logs
2. ✅ Test end-to-end development workflow
3. ✅ Share documentation with team
4. ✅ Set calendar reminders for token rotation
5. ✅ Document any custom configurations
6. ✅ Train team on secret management practices

---

**Configuration Date**: November 12, 2026  
**Status**: Ready for implementation  
**Maintainer**: ATD-S-L Organization Admins
