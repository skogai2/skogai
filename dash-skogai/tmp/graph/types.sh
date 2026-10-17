#!/usr/bin/env bash
# types.sh [--json] [dash-dir] > README.md: one section per type, from type/*.md, in type/index.md order
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
json=0
[[ ${1:-} == --json ]] && { json=1; shift; }
cd "${1:-$here/../..}"

frontmatter() {
    local fm
    fm="$(awk 'NR==1 && /^---$/ {f=1; next} f && /^---$/ {exit} f' "$1")"
    [[ -n $fm ]] || { echo '{}'; return; }
    yq -o=json '.' <<<"$fm" 2>/dev/null || yq '.' <<<"$fm"
}

body() {
    awk 'NR==1 && !/^---$/ {b=1} b; /^---$/ && ++c==2 {b=1}' "$1"
}

order() {
    grep -o '](\([a-z-]*\)\.md)' type/index.md | sed 's/^](//; s/\.md)$//'
}

records() {
    local f
    for f in type/*.md type/*/*.md; do
        [[ $(basename "$f") == index.md ]] && continue
        frontmatter "$f" | jq -c --arg file "$f" --arg body "$(body "$f")" '. + {file: $file, body: $body}'
    done
}

records | jq -s --argjson order "$(order | jq -Rsc 'split("\n") | map(select(. != ""))')" '
    (map(select(.file | test("^type/[^/]+/"))) | map(. + {parent: (.file | split("/")[1])})) as $inst
    | map(select(.file | test("^type/[^/]+\\.md$")) | . + {name: (.file | ltrimstr("type/") | rtrimstr(".md"))})
    | map(.name as $n | . + {instances: [$inst[] | select(.parent == $n) | {title, file}]})
    | sort_by(.name as $n | ($order | index($n)) // 999)' \
| if ((json)); then cat; else jq -r -f "$here/types.jq" --arg rev "$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"; fi
