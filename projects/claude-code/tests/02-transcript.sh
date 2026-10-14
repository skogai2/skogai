# The run writes a real transcript into the sandbox config dir.
set -euo pipefail
echo "Reply with exactly the word pong." | bin/agent >/dev/null
t=$(bin/transcript)
[[ -n $t ]] || { echo "no transcript in /tmp/claude-code/baseline/config/projects"; exit 1; }
jq -e 'select(.type=="assistant") | .message.content[] | select(.type=="text") | .text | ascii_downcase | contains("pong")' "$t" >/dev/null \
  || { echo "assistant reply missing from $t"; exit 1; }
