#!/usr/bin/env bash
# skogcli script for the [@date:...] notation idiom.
# Usage: skogcli script run date -- <now|unix|iso|<strftime-format>>
set -euo pipefail

arg="${1:-now}"

case "$arg" in
  now)
    date -u +"%Y-%m-%dT%H:%M:%SZ"
    ;;
  unix)
    date -u +%s
    ;;
  iso)
    date -u +"%Y-%m-%dT%H:%M:%SZ"
    ;;
  *)
    # Anything else is treated as a raw strftime format string for `date`.
    date -u +"$arg"
    ;;
esac
