#!/usr/bin/env bash
# types.sh [dash-dir] > types.md: render type/ frontmatter as a mermaid graph and a table
set -euo pipefail
cd "${1:-$(dirname "$0")/../..}"

frontmatter() {
    local fm
    fm="$(awk 'NR==1 && /^---$/ {f=1; next} f && /^---$/ {exit} f' "$1")"
    [[ -n $fm ]] || { echo '{}'; return; }
    yq -o=json '.' <<<"$fm" 2>/dev/null || yq '.' <<<"$fm"
}

records() {
    local f
    for f in type/*.md type/*/*.md; do
        [[ $(basename "$f") == index.md ]] && continue
        frontmatter "$f" | jq -c --arg file "$f" '. + {file: $file}'
    done
}

records | jq -rs -f "$(dirname "$0")/types.jq" --arg rev "$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
