# The base orchestrator prompt is appended (default prompt kept) and arrives intact.
set -euo pipefail
box=/tmp/claude-code/test-base
out=$(echo "Which setup do you use to write a commit message? Reply with the setup name only." \
  | SETUP=base BOX=$box bin/agent)
[[ $out == *commit-msg* ]] || { echo "got: $out"; exit 1; }
chars=$(jq -s '[.[] | select(.attachment.type=="prompt_snapshot") | .attachment.systemPrompt | tostring | length] | max' \
  "$box"/config/projects/*/*.jsonl)
[[ $chars -gt 2000 ]] || { echo "base: expected the default prompt, got $chars chars"; exit 1; }
