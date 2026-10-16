# Loadout: the plugin loads in -p from setups/loadout/plugin-dirs, uses the
# seeded store (no second store file appears), and LOADOUT=vanilla drops the
# project CLAUDE.md that LOADOUT=default keeps.
set -euo pipefail
export SETUP=loadout BOX=/tmp/claude-code/test-loadout
q="What is the canary word? Reply with just the word, or NONE."

out=$(echo "$q" | LOADOUT=default OUTPUT=stream-json bin/agent)
jq -e 'select(.type=="system" and .subtype=="init") | .plugins | any(.name=="loadout")' <<<"$out" >/dev/null \
  || { echo "loadout missing from init plugins"; exit 1; }
answer=$(jq -r 'select(.type=="result") | .result' <<<"$out")
[[ $answer == *PINEAPPLE* ]] || { echo "default profile: expected PINEAPPLE, got: $answer"; exit 1; }
stores=$(ls "$BOX"/config/plugins/store/loadout_*.json | wc -l)
[[ $stores -eq 1 ]] || { echo "expected 1 loadout store, found $stores (plugin path hash changed?)"; exit 1; }

answer=$(echo "$q" | LOADOUT=vanilla bin/agent)
[[ $answer != *PINEAPPLE* ]] || { echo "vanilla profile: CLAUDE.md still loaded"; exit 1; }

if echo "$q" | LOADOUT=no-such-profile bin/agent >/dev/null 2>&1; then
  echo "unknown LOADOUT profile did not fail"; exit 1
fi
