#!/usr/bin/env bash
set -euo pipefail

# Enforces branch merge order: dev -> main
# Also allows feature/* branches to merge into dev

ALLOWED_MERGES=(
  "dev:main"
)

MERGE_KEY="${HEAD_BRANCH}:${BASE_BRANCH}"

# Allow feature branches into dev
if [[ "${HEAD_BRANCH}" == feature/* && "${BASE_BRANCH}" == "dev" ]]; then
  echo "✅ Allowed: feature branch -> dev"
  exit 0
fi

# Allow hotfix branches into main
if [[ "${HEAD_BRANCH}" == hotfix/* && "${BASE_BRANCH}" == "main" ]]; then
  echo "✅ Allowed: hotfix branch -> main"
  exit 0
fi

for allowed in "${ALLOWED_MERGES[@]}"; do
  if [[ "${MERGE_KEY}" == "${allowed}" ]]; then
    echo "✅ Allowed merge: ${HEAD_BRANCH} -> ${BASE_BRANCH}"
    exit 0
  fi
done

echo "❌ Merge not allowed: ${HEAD_BRANCH} -> ${BASE_BRANCH}"
echo "Allowed merge order: feature/* -> dev -> main"
echo "Hotfix branches may merge directly to main."
exit 1
