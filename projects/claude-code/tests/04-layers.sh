# Layers: a setup without settings.json inherits baseline's stripping, and a
# setup with only append-system-prompt.md keeps Claude Code's default prompt.
set -euo pipefail

init=$(echo "reply with: ok" | SETUP=commit-msg BOX=/tmp/claude-code/test-layers OUTPUT=stream-json bin/agent \
  | jq -c 'select(.type=="system" and .subtype=="init")')
for key in tools skills mcp_servers plugins slash_commands; do
  n=$(jq ".$key | length" <<<"$init")
  [[ $n -eq 0 ]] || { echo "commit-msg: $key not empty: $(jq -c ".$key" <<<"$init")"; exit 1; }
done

box=/tmp/claude-code/test-layers
echo "reply with: ok" | SETUP=orchestration BOX=$box bin/agent >/dev/null
chars=$(jq -s '[.[] | select(.attachment.type=="prompt_snapshot") | .attachment.systemPrompt | tostring | length] | max' \
  "$box"/config/projects/*/*.jsonl)
[[ $chars -gt 2000 ]] || { echo "orchestration: expected the default prompt, got $chars chars"; exit 1; }
