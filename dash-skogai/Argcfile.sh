#!/usr/bin/env bash
# shellcheck disable=SC2154 # argc_* variables are injected by argc at runtime
# the cli, run as `argc <cmd>`. no commands yet: config is plain `mise config`
# (see type/tool/mise.md). a command is `# @cmd` + a function calling
# `_run_script`, which runs `bin/skogai-<function name>`.
set -e

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
