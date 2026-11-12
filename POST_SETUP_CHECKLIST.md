# Post-Setup Checklist

Complete this checklist before considering the automation setup ready for production.

## Phase 1: Merge & Initial Setup

- [ ] **Branch Merges**
  - [ ] `pgarciaatd-setup-automations-final` → `main` in apps-backend
  - [ ] `pgarciaatd-setup-automations-final` → `main` in apps-frontend
  - [ ] `pgarciaatd-setup-automations-final` → `main` in firmware-esp32
  - [ ] `pgarciaatd-setup-automations-final` → `main` in core-libraries

- [ ] **Verify Main Branch Status**
  - [ ] All 4 repos have clean main branch
  - [ ] No merge conflicts
  - [ ] All CI checks pass after merge

- [ ] **Branch Cleanup**
  - [ ] Delete feature branch from all repos
  - [ ] Update local checkouts: `git pull origin main`

## Phase 2: Secrets Configuration

### Global Configuration

- [ ] **Slack Setup** (if using notifications)
  - [ ] Create Slack App in workspace
  - [ ] Enable Incoming Webhooks
  - [ ] Generate webhook URL
  - [ ] Add `SLACK_WEBHOOK_URL` to all 4 repositories
  - [ ] Test webhook: Send test message via curl

### apps-backend

- [ ] **SonarQube** (if using code quality)
  - [ ] Access SonarQube instance
  - [ ] Generate API token
  - [ ] Add `SONARQUBE_TOKEN` to secrets
  - [ ] Add `SONARQUBE_HOST_URL` to variables
  - [ ] Verify `build.yml` references are correct

### apps-frontend

- [ ] **Lighthouse CI** (if using performance monitoring)
  - [ ] Create GitHub Personal Access Token
  - [ ] Set scope: `repo`, `write:packages`
  - [ ] Add `LIGHTHOUSE_CI_GITHUB_TOKEN` to secrets
  - [ ] Create `.lighthouserc.json` (optional, for thresholds)

### firmware-esp32

- [ ] **Snyk Security** (optional, if using vulnerability scanning)
  - [ ] Create Snyk account (if not existing)
  - [ ] Generate API token
  - [ ] Add `SNYK_TOKEN` to secrets
  - [ ] (Workflow will run but won't fail on Snyk errors if not configured)

### core-libraries

- [ ] **npm Publishing**
  - [ ] Create npm account (if not existing)
  - [ ] Generate Automation-type access token
  - [ ] Add `NPM_TOKEN` to secrets (CRITICAL)
  - [ ] Test: Attempt dry-run publish or manual test

## Phase 3: Workflow Verification

### Test Runs

- [ ] **apps-backend Build Workflow**
  - [ ] Trigger manually from Actions tab
  - [ ] Verify build.yml completes
  - [ ] Verify artifacts uploaded
  - [ ] Check SonarQube scan runs (if configured)

- [ ] **apps-frontend Build Workflow**
  - [ ] Trigger manually from Actions tab
  - [ ] Verify React build completes
  - [ ] Verify Lighthouse check runs
  - [ ] Check artifacts upload

- [ ] **firmware-esp32 Build Workflow**
  - [ ] Trigger manually from Actions tab
  - [ ] Verify PlatformIO builds for all platforms
  - [ ] Verify .bin files generated with checksums
  - [ ] Check artifact uploads

- [ ] **core-libraries Test Workflow**
  - [ ] Trigger manually from Actions tab
  - [ ] Verify npm tests pass
  - [ ] Verify coverage generation
  - [ ] Check artifacts

### Code Quality Workflows

- [ ] **apps-backend Code Quality**
  - [ ] Trigger manually
  - [ ] Verify ESLint output
  - [ ] Verify security audit runs
  - [ ] Check artifact uploads

- [ ] **apps-frontend Code Quality**
  - [ ] Trigger manually
  - [ ] Verify ESLint/Prettier checks
  - [ ] Verify performance metrics generated
  - [ ] Bundle analysis available

- [ ] **firmware-esp32 Code Quality**
  - [ ] Trigger manually
  - [ ] Verify Pylint/Flake8 run
  - [ ] Verify security audit (Bandit)
  - [ ] Check Python metrics

- [ ] **core-libraries Code Quality**
  - [ ] Trigger manually
  - [ ] Verify all metrics generated
  - [ ] Verify security audit runs
  - [ ] Check documentation builds

### Notification Workflows

- [ ] **Slack Notifications** (if configured)
  - [ ] Trigger a workflow run
  - [ ] Verify Slack message appears in configured channel
  - [ ] Check message format is readable
  - [ ] Verify status emoji (✅/❌) displays correctly

- [ ] **GitHub Notifications**
  - [ ] Trigger test PR with failing workflow
  - [ ] Verify PR comment created with failure notification
  - [ ] Check link to workflow run works

## Phase 4: Release & Automation Testing

### Dependabot Verification

- [ ] **apps-backend Dependabot**
  - [ ] Wait 24-48 hours or check status manually
  - [ ] Verify PR created for npm updates
  - [ ] Verify labels added (dependencies, automated)
  - [ ] Verify auto-assigned to pgarciaatd
  - [ ] Check security update PR (separate from regular updates)

- [ ] **apps-frontend Dependabot**
  - [ ] Verify npm PRs created
  - [ ] Verify GitHub Actions PRs created
  - [ ] Check security PRs separate

- [ ] **firmware-esp32 Dependabot**
  - [ ] Verify Python (pip) PRs created
  - [ ] Verify GitHub Actions PRs created
  - [ ] Check security PRs

- [ ] **core-libraries Dependabot**
  - [ ] Verify npm updates
  - [ ] Verify Actions updates
  - [ ] Check security updates

### Release Testing

- [ ] **apps-backend Release Test**
  - [ ] Create test branch with a feat commit
  - [ ] Merge PR with `feat: new feature` message
  - [ ] Trigger deploy manually or wait for automatic
  - [ ] Verify version bumped in package.json
  - [ ] Verify CHANGELOG.md updated
  - [ ] Verify GitHub Release created
  - [ ] Check tags created: `git tag -l`

- [ ] **apps-frontend Release Test**
  - [ ] Same flow as backend
  - [ ] Verify no npm publish (npmPublish: false in config)
  - [ ] Verify GitHub Release created

- [ ] **firmware-esp32 Release Test**
  - [ ] Same flow with firmware-specific commit
  - [ ] Verify firmware binaries in release
  - [ ] Verify checksums included

- [ ] **core-libraries Release Test** (IMPORTANT)
  - [ ] Create test branch with `feat:` commit
  - [ ] Merge to main
  - [ ] Trigger deploy manually
  - [ ] Check npm publish happened
  - [ ] Verify new version available: `npm view @yourorg/core-libraries versions`
  - [ ] Verify GitHub Packages updated
  - [ ] Test installation: `npm install @yourorg/core-libraries@latest`

## Phase 5: Documentation & Communication

- [ ] **Team Documentation**
  - [ ] Add workflow guide to each repo's README
  - [ ] Document workflow triggers (push, PR, schedule, manual)
  - [ ] Add troubleshooting section
  - [ ] Link to AUTOMATION_COMPLETE.md

- [ ] **Team Communication**
  - [ ] Notify team in Slack of new automations
  - [ ] Share AUTOMATION_COMPLETE.md in team channel
  - [ ] Share GITHUB_SECRETS_GUIDE.md with relevant members
  - [ ] Schedule training session on new workflows
  - [ ] Document expected behavior for dependabot PRs

- [ ] **Wiki/Knowledge Base**
  - [ ] Add automations page to team wiki
  - [ ] Document release process
  - [ ] Add troubleshooting guide
  - [ ] Document secrets rotation procedure

## Phase 6: Monitoring & Maintenance

### Ongoing Monitoring

- [ ] **First Week**
  - [ ] Monitor all workflow runs daily
  - [ ] Check Slack notifications working
  - [ ] Review Dependabot PRs created
  - [ ] Fix any failing workflows
  - [ ] Monitor artifact uploads

- [ ] **First Month**
  - [ ] All scheduled workflows have run
  - [ ] Dependabot updates working as expected
  - [ ] No unexpected failures
  - [ ] Team comfortable with new workflows
  - [ ] Documentation complete and accurate

- [ ] **Ongoing**
  - [ ] Weekly review of workflow failures
  - [ ] Monthly rotation of npm/GitHub tokens
  - [ ] Quarterly review of workflow configs
  - [ ] Keep action versions updated

### Maintenance Tasks

- [ ] **Token Rotation** (schedule quarterly)
  - [ ] Rotate `NPM_TOKEN` (90-day cycle)
  - [ ] Rotate `SONARQUBE_TOKEN` (if using)
  - [ ] Rotate personal access tokens (if any)
  - [ ] Update secrets without workflow changes

- [ ] **Dependency Updates**
  - [ ] Keep GitHub Actions versions current
  - [ ] Review and approve dependabot PRs
  - [ ] Monitor security advisories
  - [ ] Update action versions in workflows

- [ ] **Workflow Optimization**
  - [ ] Review action execution times
  - [ ] Optimize cache hit rates
  - [ ] Remove unused workflows
  - [ ] Add new workflows as needed

## Critical Success Criteria

✅ **All of these must be true before production release:**

1. All 4 repos successfully merged to main
2. All required secrets configured
3. At least one successful build in each repo
4. Dependabot PRs created and working
5. Release workflow created at least one version
6. Slack notifications working (if configured)
7. No blocking errors in any workflow
8. Team trained on new automation system
9. Documentation complete and accessible
10. Monitoring and alerting in place

## Rollback Plan

If issues occur, ability to rollback:

- [ ] Feature branch still exists for quick revert
- [ ] Rollback command: `git revert <commit-hash>` on each repo
- [ ] Alternative: Delete .github/workflows and configs from main
- [ ] Previous versions still available in git history
- [ ] No data loss (workflows are reversible)

## Approval Sign-Off

- [ ] **Technical Lead**: _________________ Date: _______
- [ ] **DevOps/Automation Owner**: _________________ Date: _______
- [ ] **Team Lead**: _________________ Date: _______

---

## Notes

Use this section to document any deviations or custom configurations:

```
[Add notes here about your specific setup]
```

---

**Checklist Version**: 1.0
**Last Updated**: 2026-11-12
**Owner**: ATD-S-L DevOps Team
**Expected Completion Time**: 1-2 weeks from merge
