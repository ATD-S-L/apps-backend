#!/bin/bash
# Configure branch protection for ATD-S-L repositories
# Usage: ./scripts/configure-branch-protection.sh <repo-owner> <repo-name> <github-token>

set -e

OWNER="${1:-ATD-S-L}"
REPO="${2:-apps-backend}"
TOKEN="${3:-$GITHUB_TOKEN}"

if [ -z "$TOKEN" ]; then
  echo "Error: GitHub token is required. Set GITHUB_TOKEN or pass it as third argument."
  exit 1
fi

BRANCH="main"
API_URL="https://api.github.com/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection"

echo "Configuring branch protection for ${OWNER}/${REPO}:${BRANCH}..."

curl -X PUT "${API_URL}" \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["Test", "Build"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": false,
      "required_approving_review_count": 1
    },
    "restrictions": null,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "require_linear_history": false,
    "required_conversation_resolution": false,
    "allow_auto_merge": true
  }'

echo ""
echo "✅ Branch protection configured successfully for ${OWNER}/${REPO}:${BRANCH}"
