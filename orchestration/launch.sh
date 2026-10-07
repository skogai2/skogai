#!/usr/bin/env bash
# Start the skogai orchestrator: a Claude Code session with the herdr skill
# and the orchestrator rules. Run it from a herdr pane in ~/skogai.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

[ "${HERDR_ENV:-}" = 1 ] || { echo "launch.sh: not inside a herdr pane (HERDR_ENV != 1)" >&2; exit 1; }

# Project map: every submodule's SKOGAI.md, regenerated on each start so it
# matches the submodules as they are now. The root SKOGAI.md is excluded: it
# is already loaded natively, via AGENTS.md -> @SKOGAI.md -> @TOOLS.md.
mkdir -p tmp
find . -mindepth 2 -name SKOGAI.md -not -path '*/.git/*' -print0 | sort -z | xargs -0 cat > tmp/SKOGAI-PROJECTS

# herdr --skill prints the agent skill; the rules and the project map follow it.
prompt="$(herdr --skill)

$(cat orchestration/ORCHESTRATOR.md)

# Projects in skogai

$(cat tmp/SKOGAI-PROJECTS)"

exec claude --append-system-prompt "$prompt" "$@"
