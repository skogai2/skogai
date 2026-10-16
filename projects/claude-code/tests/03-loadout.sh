# Loadout: the plugin loads in -p, keeps its store in the sandbox, and its
# vanilla profile drops the project CLAUDE.md that default keeps.
set -euo pipefail
plugin=$(ls -d "$HOME"/.claude/plugins/cache/*/loadout/*/ 2>/dev/null | sort -V | tail -1)
[[ -n $plugin ]] || { echo "loadout plugin not installed"; exit 1; }
export SETUP=loadout BOX=/tmp/claude-code/test-loadout
q="What is the canary word? Reply with just the word, or NONE."

out=$(echo "$q" | OUTPUT=stream-json bin/agent --plugin-dir "$plugin")
jq -e 'select(.type=="system" and .subtype=="init") | .plugins | any(.name=="loadout")' <<<"$out" >/dev/null \
  || { echo "loadout missing from init plugins"; exit 1; }
answer=$(jq -r 'select(.type=="result") | .result' <<<"$out")
[[ $answer == *PINEAPPLE* ]] || { echo "default profile: expected PINEAPPLE, got: $answer"; exit 1; }

store=$(ls "$BOX"/config/plugins/store/loadout_*.json 2>/dev/null | head -1)
[[ -n $store ]] || { echo "no loadout store in the sandbox config"; exit 1; }
jq '.active = "vanilla"' "$store" >"$store.new" && mv "$store.new" "$store"

answer=$(echo "$q" | KEEP=1 bin/agent --plugin-dir "$plugin")
[[ $answer != *PINEAPPLE* ]] || { echo "vanilla profile: CLAUDE.md still loaded"; exit 1; }
