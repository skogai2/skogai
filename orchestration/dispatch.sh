#!/usr/bin/env bash
# Dispatch one work order to a worker agent in its own herdr worktree.
#   orchestration/dispatch.sh <id>
# Extra arguments for the worker's claude process: ORCH_WORKER_ARGS, e.g.
#   ORCH_WORKER_ARGS="--permission-mode acceptEdits" orchestration/dispatch.sh fix-x
set -euo pipefail

die() { echo "dispatch.sh: $*" >&2; exit 1; }

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ "${HERDR_ENV:-}" = 1 ] || die "not inside a herdr pane (HERDR_ENV != 1)"
[ "$#" -eq 1 ] || die "usage: dispatch.sh <id>"

id="$1"
[[ "$id" =~ ^[a-z][a-z0-9-]{0,20}$ ]] || die "id must match [a-z][a-z0-9-]{0,20}"
order="$root/orchestration/orders/$id.md"
[ -f "$order" ] || die "no order at orchestration/orders/$id.md"

# Read one frontmatter field from the order.
field() { sed -n "s/^$1: *//p" "$order" | head -1; }

repo="$(field repo)"; branch="$(field branch)"; base="$(field base)"; status="$(field status)"
base="${base:-master}"
[ -n "$repo" ] && [ -n "$branch" ] || die "order $id needs repo and branch"
[ -d "$root/$repo" ] || die "repo $repo is not a checkout"
[ "$status" = "open" ] || die "order $id status is '$status', expected 'open'"

# Worktree on the order's branch, opened in its own workspace (not focused).
created="$(herdr worktree create --cwd "$root/$repo" --branch "$branch" --base "$base" --no-focus)"
pane="$(jq -r '.result.root_pane.pane_id' <<<"$created")"
worktree="$(jq -r '.result.worktree.path' <<<"$created")"
[ -n "$pane" ] && [ "$pane" != null ] || die "worktree create gave no pane: $created"

name="wo-$id"
# shellcheck disable=SC2086
if ! herdr agent start "$name" --kind claude --pane "$pane" -- ${ORCH_WORKER_ARGS:-} >/dev/null; then
  # A new worktree opens Claude's folder-trust prompt, which blocks startup.
  echo "dispatch.sh: worker $name did not start in pane $pane (likely the folder-trust prompt)." >&2
  echo "  Accept the prompt in that pane, then: herdr agent prompt $name \"<order text>\"" >&2
  exit 1
fi

prompt="You are worker $name for skogai work order orchestration/orders/$id.md
in $root. Your working directory is the worktree $worktree on branch $branch.

1. Read the order file at $root/orchestration/orders/$id.md. The task and
   acceptance criteria are there. Do not edit it.
2. Work only inside this worktree. Do not touch other checkouts.
3. Implement, run the repo's tests or checks, and commit on $branch.
4. Push $branch and open a pull request against $base with gh. End the PR
   body with: 🤖 Generated with [Claude Code](https://claude.com/claude-code)
5. Finish with one line: PR_URL=<url>, or NO_PR=<reason>. Do not merge."

# No --wait: the worker runs for as long as the task takes. Watch it with
# `herdr agent wait wo-<id>`.
herdr agent prompt "$name" "$prompt" >/dev/null

# Record what was started, so the order is the record of truth.
tmp="$(mktemp)"
awk -v pane="$pane" -v wt="$worktree" '
  /^status:/   { print "status: running"; next }
  /^pane:/     { print "pane: " pane; next }
  /^worktree:/ { print "worktree: " wt; next }
  { print }
' "$order" > "$tmp"
mv "$tmp" "$order"

echo "dispatched $id: agent $name in pane $pane ($worktree)"
