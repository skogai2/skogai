#!/usr/bin/env bash
set -e

# @describe get SKOGAI_PROJECT_NAME

main() {
  gh repo view --json name | jq ".name" --raw-output
}

eval "$(argc --argc-eval "$0" "$@")"
