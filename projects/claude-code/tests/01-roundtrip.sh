# The model answers and follows the system prompt.
set -euo pipefail
out=$(echo "Reply with exactly the word pong and nothing else." | bin/agent)
[[ ${out,,} == *pong* ]] || { echo "got: $out"; exit 1; }
