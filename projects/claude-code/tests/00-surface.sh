# Baseline: the agent exposes nothing beyond the model itself.
set -euo pipefail
init=$(echo "reply with: ok" | OUTPUT=stream-json bin/agent | jq -c 'select(.type=="system" and .subtype=="init")')
for key in tools skills mcp_servers plugins slash_commands; do
  n=$(jq ".$key | length" <<<"$init")
  [[ $n -eq 0 ]] || { echo "$key not empty: $(jq -c ".$key" <<<"$init")"; exit 1; }
done
