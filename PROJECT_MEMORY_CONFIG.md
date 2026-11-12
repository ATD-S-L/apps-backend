# 🧠 PROJECT MEMORY - ATD-S-L Configuration

**Last Updated**: November 12, 2026  
**Status**: Active & Current

---

## Configuration Snapshot

### Current Setup Status
```
PHASE: Setup Completed ✅
DATE: November 12, 2026
BRANCHES_MERGED: All feature branches → main
DEPLOYMENT_STATUS: Ready for development
```

### Repository Inventory

| Repository | GitHub URL | Purpose | Status |
|---|---|---|---|
| **apps-backend** | github.com/ATD-S-L/apps-backend | Backend API & Logic | ✅ Ready |
| **apps-frontend** | github.com/ATD-S-L/apps-frontend | Web UI & Views | ✅ Ready |
| **firmware-esp32** | github.com/ATD-S-L/firmware-esp32 | ESP32 Embedded Code | ✅ Ready |
| **core-libraries** | github.com/ATD-S-L/core-libraries | Shared Code & Docs | ✅ Ready |

---

## Technology Stack Decisions

### Backend (TBD - Decide in Sprint 1)
**Recommended Options**:
- Node.js + Express.js (Full-stack JS option)
- Python + FastAPI (Data science friendly)
- Rust + Actix-web (Performance critical)

**Decision Criteria**:
- Performance requirements
- Team expertise
- Scaling requirements

### Frontend (TBD - Decide in Sprint 1)
**Recommended Options**:
- React + TypeScript (Industry standard)
- Vue 3 + TypeScript (Lighter framework)
- Next.js (Full-stack React)

**Decision Criteria**:
- UI/UX complexity
- SSR requirements
- Bundle size constraints

### Firmware (DECIDED)
- **Language**: C/C++
- **Framework**: ESP-IDF (Espressif IoT Development Framework)
- **Compiler**: xtensa-esp32-elf-gcc

### DevOps (DECIDED)
- **CI/CD Platform**: GitHub Actions
- **Package Management**: npm (JS), pip (Python), cargo (Rust)
- **Testing Framework**: Jest (JS), pytest (Python), catch2 (C++)
- **Versioning**: Semantic Versioning (see ADR-004)

---

## Active Automations

### Pre-commit Hooks
**Location**: All repos have `.pre-commit-config.yaml`
- ✅ Commit message linting
- ✅ Code formatting (Prettier)
- ✅ ESLint for JS/TS files
- ✅ Trailing whitespace check

**Installation**:
```bash
pip install pre-commit
pre-commit install
```

### CI/CD Pipelines

#### apps-backend
```yaml
build.yml      # Triggers on push to main/PRs
test.yml       # Run test suite
deploy.yml     # Auto-deploy to staging
```

#### apps-frontend
```yaml
build.yml      # Build static assets
test.yml       # E2E and unit tests
deploy.yml     # Deploy to CDN
```

#### firmware-esp32
```yaml
binary.yml     # Compile ESP32 binaries
lint.yml       # Static analysis C/C++
test.yml       # Unit tests
```

#### core-libraries
```yaml
publish.yml    # Publish to npm/artifactory
test.yml       # Run test suite
```

### Branch Protection Rules (main branch)
- ❌ Direct push disabled
- ✅ Require 1 pull request review
- ✅ Require CI/CD to pass
- ✅ Dismiss stale reviews on new commits
- ✅ Require branches to be up to date

---

## Key Documentation Files

### In core-libraries
```
ARCHITECTURE.md          → System design & component overview
SETUP_GUIDE.md          → Step-by-step setup instructions
TECHNOLOGY_MATRIX.md    → Tech stack decisions with justification
CONTRIBUTING.md         → Developer guidelines
README.md              → Project overview
ADR/                   → Architecture Decision Records
  ├── 001-multi-repo-strategy.md
  ├── 002-cicd-approach.md
  ├── 003-pre-commit-quality-gates.md
  ├── 004-semantic-versioning.md
  └── 005-deployment-approach.md
```

### In each repository
```
README.md               → Repo-specific information
CONTRIBUTING.md        → Contribution guidelines
.github/workflows/     → CI/CD configuration
.pre-commit-config.yaml → Pre-commit hooks
package.json/requirements.txt/CMakeLists.txt → Dependencies
```

---

## Development Workflow

### Standard Sprint Cycle
```
[PLAN] → [FEATURE BRANCH] → [PR] → [CODE REVIEW] → [CI/CD CHECK] → [MERGE] → [DEPLOY]
```

### Branch Naming Convention
```
feat/feature-description    # New features
fix/bug-description         # Bug fixes
docs/doc-topic             # Documentation
refactor/component-name     # Refactoring
chore/task-description      # Maintenance
```

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: feat, fix, docs, style, refactor, perf, test, chore
**Example**: `feat(auth): add JWT token validation`

### Code Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] CI/CD passes all checks

---

## Secrets & Environment Variables

### Required Secrets (Setup in GitHub)
Each repository needs these secrets configured in Settings → Secrets and variables:

**For Node.js repos**:
- `NPM_TOKEN` - For private npm package publishing

**For Python repos**:
- `PYPI_API_TOKEN` - For PyPI publishing

**For all repos**:
- `SLACK_WEBHOOK` - For notifications (optional)
- `CODECOV_TOKEN` - For coverage reports (optional)

### Environment Files
Each repo uses `.env.example` template:
- Copy to `.env.local` for development
- Add to `.gitignore`
- Never commit secrets

---

## Deployment Strategy

### Staging Environment
- **Trigger**: Auto on merge to main
- **Target**: Staging servers
- **Validation**: Smoke tests

### Production Environment
- **Trigger**: Manual (workflow_dispatch)
- **Target**: Production servers
- **Validation**: Full test suite + manual approval

### Rollback Procedure
1. Create a new PR that reverts the problematic commit
2. Merge to main
3. Deploy normally
4. Post-incident review

---

## Performance & Monitoring

### Code Quality Gates
- ✅ Test coverage minimum: 70%
- ✅ ESLint: All errors must pass
- ✅ Prettier: Auto-format on pre-commit
- ✅ Security scan: npm audit / safety check

### Monitoring Setup (TBD)
To be configured in Sprint 1:
- Error tracking (Sentry recommended)
- Performance monitoring (New Relic/DataDog)
- Log aggregation (ELK stack / CloudWatch)
- Uptime monitoring (StatusCake / UptimeRobot)

---

## First Sprint Priorities

### Week 1: Tech Stack & Setup
- [ ] Choose backend stack
- [ ] Choose frontend framework
- [ ] Initialize boilerplate code
- [ ] Validate local development setup

### Week 2: First Feature
- [ ] Create simple API endpoint
- [ ] Create simple UI component
- [ ] End-to-end integration test
- [ ] Validate CI/CD pipeline

### Week 3: Hardening
- [ ] Add error handling
- [ ] Add logging
- [ ] Add authentication skeleton
- [ ] Performance optimization

### Week 4: Documentation & Refinement
- [ ] Update architecture docs
- [ ] Create runbooks
- [ ] Conduct retrospective
- [ ] Plan Sprint 2

---

## Known Issues & Workarounds

### Issue #1: Branch naming in apps-backend
**Status**: Resolved  
**Solution**: Used branches that exist (setup-cicd, improved-couscous)

### Issue #2: ESP32 build failures
**Status**: TBD  
**Solution**: Will be addressed when first firmware module is added

---

## Team Access & Permissions

### Repository Access
- All team members: Read access to public repos
- Core team: Write access to all repos
- Maintainers: Admin access

### Branch Protection
- Main branch: Protected
- Development branch (if used): Can be less restrictive
- Feature branches: Deletable after merge

---

## Resource Links

### GitHub Organization
- https://github.com/ATD-S-L

### Key Documentation
- Main Docs: https://github.com/ATD-S-L/core-libraries
- ADRs: https://github.com/ATD-S-L/core-libraries/tree/main/ADR

### CI/CD Status
- apps-backend: https://github.com/ATD-S-L/apps-backend/actions
- apps-frontend: https://github.com/ATD-S-L/apps-frontend/actions
- firmware-esp32: https://github.com/ATD-S-L/firmware-esp32/actions
- core-libraries: https://github.com/ATD-S-L/core-libraries/actions

---

## Maintenance Schedule

### Weekly Tasks
- Review and merge PRs
- Check CI/CD pipeline status
- Monitor error tracking dashboard

### Monthly Tasks
- Dependency updates (npm/pip/cargo)
- Security audit (npm audit, safety, cargo audit)
- Performance review
- Documentation review

### Quarterly Tasks
- Architecture review
- Stack evaluation
- Planning for upcoming phases

---

## Future Enhancements

### Phase 2 (Post-Sprint 5)
- [ ] Docker containerization
- [ ] Kubernetes deployment
- [ ] Advanced monitoring & alerting
- [ ] Performance optimization
- [ ] Security hardening

### Phase 3 (Post-Sprint 10)
- [ ] Multi-region deployment
- [ ] Advanced caching strategy
- [ ] Database optimization
- [ ] API rate limiting & throttling

---

**Version**: 1.0  
**Last Sync**: November 12, 2026  
**Owner**: ATD-S-L Core Team  
**Status**: 🟢 Active
