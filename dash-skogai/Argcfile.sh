#!/usr/bin/env bash
set -e


# @cmd skogai-config
# @arg args~[?`_choice_script`]
config() { _run_script "$@"; }

_run_script() {
  bash "./bin/skogai-${FUNCNAME[1]}" "$@"
}

_choice_script() {
  [[ "$ARGC_COMPGEN" -eq 1 ]] || return 0
  local args=("${argc__positionals[@]}")
  args[-1]="$ARGC_LAST_ARG"
  argc --argc-compgen generic "./bin/skogai-$argc__cmd_fn" "$argc__cmd_fn" "${args[@]}"
}

eval "$(argc --argc-eval "$0" "$@")"
