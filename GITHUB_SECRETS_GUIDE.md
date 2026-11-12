# GitHub Secrets Configuration Guide

## Overview
This guide explains how to configure the required GitHub secrets for automated workflows in each repository.

## Steps to Configure Secrets

### 1. Repository Settings Access
1. Go to your repository on GitHub
2. Click **Settings** (top-right)
3. Scroll to **Secrets and variables** → **Actions**
4. Click **New repository secret**

### 2. Global Secrets (All Repositories)

#### GITHUB_TOKEN
- **Type**: Automatic (provided by GitHub Actions)
- **Status**: No manual configuration needed
- **Use**: Authenticates GitHub Actions to GitHub API
- **Scope**: Automatically scoped to current repository

---

## Repository-Specific Secrets

### apps-backend

#### SONARQUBE_TOKEN (Optional)
```
Name: SONARQUBE_TOKEN
Value: <Your SonarQube token from admin panel>
```
- **Purpose**: Authenticates SonarQube code quality scans
- **Obtain**: SonarQube Server → Account → Security → Generate token
- **Required**: Only if using SonarQube integration
- **Workflow**: `build.yml`

#### SONARQUBE_HOST_URL (Optional)
```
Name: SONARQUBE_HOST_URL
Value: https://sonarqube.yourcompany.com
```
- **Purpose**: SonarQube server URL
- **Format**: Must include protocol (https://)
- **Required**: Only if using SonarQube

#### SLACK_WEBHOOK_URL (Optional)
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```
- **Purpose**: Sends workflow notifications to Slack
- **Obtain**: Slack Workspace → App Directory → Incoming Webhooks → Create New Webhook
- **Required**: Only if you want Slack notifications
- **Scope**: Variable (less secure)

---

### apps-frontend

#### LIGHTHOUSE_CI_GITHUB_TOKEN (Optional)
```
Name: LIGHTHOUSE_CI_GITHUB_TOKEN
Value: <GitHub Personal Access Token>
```
- **Purpose**: Lighthouse CI reporting and artifact upload
- **Obtain**: GitHub → Settings → Developer settings → Personal access tokens
- **Required**: Only if using Lighthouse CI
- **Permissions**: `repo`, `write:packages`
- **Workflow**: `build.yml`

#### SLACK_WEBHOOK_URL (Optional)
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```
- **Purpose**: Workflow notifications
- **Obtain**: Same as apps-backend
- **Scope**: Variable (less secure)

---

### firmware-esp32

#### SNYK_TOKEN (Optional)
```
Name: SNYK_TOKEN
Value: <Your Snyk API token>
```
- **Purpose**: Security vulnerability scanning via Snyk
- **Obtain**: Snyk.io → Account Settings → API Token
- **Required**: Only if using Snyk for Python security
- **Workflow**: `code-quality.yml`

#### SLACK_WEBHOOK_URL (Optional)
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```
- **Purpose**: Firmware build notifications
- **Obtain**: Slack Webhook (see above)

---

### core-libraries

#### NPM_TOKEN (Required for Publishing)
```
Name: NPM_TOKEN
Value: <Your npm authentication token>
```
- **Purpose**: Authenticates npm publish command
- **Obtain**: npm.com → Account → Access Tokens → Generate New Token
- **Token Type**: Select "Automation" or "Publish"
- **Registry**: https://registry.npmjs.org
- **Required**: Yes (for `deploy.yml` to publish)
- **Workflow**: `deploy.yml`

#### GITHUB_TOKEN (Already Configured)
- **Status**: Already provided by GitHub Actions
- **Use**: Publishing to GitHub Packages
- **Scope**: Automatically scoped

#### SLACK_WEBHOOK_URL (Optional)
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```
- **Purpose**: Library release notifications
- **Obtain**: Slack Webhook (see above)

---

## Secrets Creation Guide by Provider

### npm Token
1. Go to https://www.npmjs.com/
2. Sign in with your account
3. Click your avatar → **Access Tokens**
4. Click **Generate New Token**
5. Select scope: **Automation** (recommended for CI/CD)
6. Copy the token
7. Add to `core-libraries` as `NPM_TOKEN` secret

### Slack Webhook
1. Go to https://api.slack.com/apps
2. Create New App → From scratch
3. Name it (e.g., "GitHub Workflows")
4. Select your workspace
5. Go to **Incoming Webhooks**
6. Toggle **Activate Incoming Webhooks** to On
7. Click **Add New Webhook to Workspace**
8. Select channel and authorize
9. Copy the Webhook URL
10. Add to each repository as `SLACK_WEBHOOK_URL` (variable scope is OK)

### GitHub Personal Access Token (for Lighthouse CI)
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Click **Generate new token** → **Generate new token (classic)**
3. Name it (e.g., "Lighthouse CI")
4. Select scopes: `repo`, `write:packages`
5. Copy and store securely
6. Add to `apps-frontend` as `LIGHTHOUSE_CI_GITHUB_TOKEN`

### SonarQube Token
1. Log into your SonarQube instance
2. Click your avatar → **My Account** → **Security**
3. Click **Generate Tokens**
4. Name it (e.g., "CI/CD Pipeline")
5. Copy the token (shown once)
6. Add to `apps-backend` as `SONARQUBE_TOKEN`

### Snyk Token
1. Go to https://app.snyk.io/
2. Sign in
3. Click your avatar → **Account settings**
4. Find **API Token**
5. Click **Show** and copy
6. Add to `firmware-esp32` as `SNYK_TOKEN`

---

## Security Best Practices

### Do's ✅
- ✅ Use **Secret** scope for sensitive tokens (auto-masked in logs)
- ✅ Use **Variable** scope only for non-sensitive settings
- ✅ Rotate tokens regularly (every 90 days recommended)
- ✅ Use dedicated CI/CD service accounts for tokens
- ✅ Limit token scopes to minimum required permissions
- ✅ Enable 2FA on npm/GitHub accounts
- ✅ Audit secret access logs periodically

### Don'ts ❌
- ❌ Commit secrets to version control
- ❌ Use personal access tokens (use service accounts)
- ❌ Share secrets via Slack/email
- ❌ Use overly broad token permissions
- ❌ Reuse tokens across multiple services
- ❌ Store secrets in environment files
- ❌ Log or print secrets in workflow output

---

## Verification

### Test Secret Configuration
To verify secrets are accessible to workflows:

1. Create a test workflow (`.github/workflows/test-secrets.yml`):
```yaml
name: Test Secrets

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Check secrets exist
        run: |
          [ ! -z "${{ secrets.GITHUB_TOKEN }}" ] && echo "✓ GITHUB_TOKEN" || echo "✗ GITHUB_TOKEN"
          [ ! -z "${{ secrets.NPM_TOKEN }}" ] && echo "✓ NPM_TOKEN" || echo "✗ NPM_TOKEN"
          [ ! -z "${{ secrets.SLACK_WEBHOOK_URL }}" ] && echo "✓ SLACK_WEBHOOK_URL" || echo "✗ SLACK_WEBHOOK_URL"
```

2. Push and check workflow runs
3. Delete the test workflow after verification

### Typical Error Messages
| Error | Cause | Fix |
|-------|-------|-----|
| `401 Unauthorized` | Invalid or missing token | Verify token value and regenerate if needed |
| `403 Forbidden` | Token lacks permissions | Check token scopes in provider settings |
| `Secret not found` | Wrong secret name | Verify exact name matches in workflow |
| `Masked value` | Token visible in logs | Always use `secrets.` prefix, never paste raw |

---

## Environment Variables vs Secrets

### Use Secrets for:
- Authentication tokens
- API keys
- Passwords
- Personal access tokens
- OAuth credentials

### Use Variables for:
- URLs (e.g., `SONARQUBE_HOST_URL`)
- Configuration flags
- Version numbers
- Non-sensitive settings

---

## Troubleshooting

### "Secret not found" Error
- Verify spelling matches exactly (case-sensitive)
- Check secret is in correct repository (not org-wide)
- Confirm workflow uses `secrets.SECRET_NAME`

### Token Expired or Invalid
- Regenerate token from provider
- Update secret value in GitHub
- No workflow restart needed

### Notification Not Sending
- Verify `SLACK_WEBHOOK_URL` is set as **Variable** (not Secret)
- Test webhook manually: `curl -X POST -H 'Content-type: application/json' --data '{"text":"Test"}' YOUR_WEBHOOK_URL`
- Check Slack channel is still active

### npm Publish Fails
- Verify `NPM_TOKEN` is set (not empty)
- Check token is "Automation" type, not "Read-only"
- Confirm `package.json` version differs from latest on npm
- Check npm registry is correct in `.npmrc` or workflow

---

## Support

- **GitHub Docs**: https://docs.github.com/en/actions/security-guides/encrypted-secrets
- **npm Documentation**: https://docs.npmjs.com/creating-and-viewing-authentication-tokens
- **Slack API**: https://api.slack.com/messaging/webhooks
- **SonarQube**: https://docs.sonarqube.org/latest/user-guide/user-token/

---

**Last Updated**: 2026-11-12
**Status**: Ready for configuration
