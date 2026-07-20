#!/usr/bin/env bash
#
# Manual deploy — does exactly what .github/workflows/deploy.yml does, minus GitHub Actions.
#
# WHY THIS EXISTS
#   Deploying this site is one command: the server fast-forwards its own clone of this repo
#   and Nginx serves that folder (hostPath mount). GitHub Actions is a convenience wrapper
#   around that command — it is not the deploy itself. So when Actions is queued or down,
#   nothing is actually blocked; run this instead.
#
#   GitHub fails in PARTS, not as a whole. On 2026-07-19 a critical Actions incident left
#   runners unassignable (our run sat "queued" for 20+ min) and the REST API returning 503,
#   while Git Operations stayed fully operational — so `git push` worked fine and only the
#   runner was missing. That asymmetry is exactly what this script exploits.
#
#   Check which part is broken before assuming it's your config:
#     curl -s https://www.githubstatus.com/api/v2/components.json \
#       | grep -o '"name":"\(Actions\|API Requests\|Git Operations\)"[^}]*"status":"[a-z_]*"'
#
# GOTCHA — always use the ssh alias, never the raw IP.
#   ~/.ssh/config maps `bit-habit` → the server, with `IdentitiesOnly yes` and the correct
#   key. Connecting to the IP directly never matches that Host block, so ssh offers the
#   default key instead and dies with "Permission denied (publickey)". The alias IS the fix.

set -euo pipefail

HOST="${DEPLOY_HOST:-bit-habit}"     # ssh alias from ~/.ssh/config — see gotcha above
BRANCH="${DEPLOY_BRANCH:-master}"
REMOTE_DIR="~/workspace/static-web"

cd "$(dirname "$0")"

# The server pulls from GitHub, so anything not pushed simply won't ship. Say so loudly
# rather than "succeeding" with a deploy that doesn't contain your work.
if [ -n "$(git status --porcelain)" ]; then
  echo "warning: you have uncommitted changes — they will NOT be deployed." >&2
fi
if [ -n "$(git log "origin/${BRANCH}..${BRANCH}" --oneline 2>/dev/null)" ]; then
  echo "error: local ${BRANCH} has unpushed commits. Run: git push origin ${BRANCH}" >&2
  exit 1
fi

LOCAL_SHA="$(git rev-parse --short "origin/${BRANCH}")"
echo "→ deploying ${LOCAL_SHA} to ${HOST} …"

# --ff-only: refuse to deploy if the server's history diverged, instead of silently merging.
#
# `git pull` writes its progress ("From github.com…", "Fast-forward") to STDERR, so we push it
# to our stderr (>&2) and keep STDOUT clean — it then contains nothing but the commit sha.
# Merging the two streams instead (2>&1) lets them interleave out of order, and `tail -1`
# picks up a pull-log line rather than the sha. That bug is why this comment exists.
if ! REMOTE_SHA="$(ssh -o BatchMode=yes -o ConnectTimeout=20 "$HOST" \
      "cd ${REMOTE_DIR} && git pull --ff-only origin ${BRANCH} >&2 && git rev-parse --short HEAD")"; then
  echo >&2
  echo "ssh/pull failed. If it says 'Permission denied (publickey)', something used the raw IP —" >&2
  echo "this script uses the '${HOST}' alias on purpose (see the gotcha at the top of this file)." >&2
  exit 1
fi

REMOTE_SHA="$(printf '%s' "$REMOTE_SHA" | tr -d '[:space:]')"

if [ "$REMOTE_SHA" = "$LOCAL_SHA" ]; then
  echo "✓ deployed — server and origin/${BRANCH} are both at ${REMOTE_SHA}"
else
  echo "! server is at ${REMOTE_SHA} but origin/${BRANCH} is ${LOCAL_SHA}" >&2
  echo "  (a concurrent push, or the pull was a no-op — check the server)" >&2
fi
echo "→ verify: https://bit-habit.com"
