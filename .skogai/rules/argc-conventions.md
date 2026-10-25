---
description: argc conventions
paths:
  - "Argcfile.sh"
  - "**/argc/**"
---

# argc

argc already validates, defaults, requires, and dispatches everything declared in `@arg`/`@option`/`@flag`/`@env`/`@meta` _before_ a function body runs. a function body re-implementing any of that in bash is a bug, not a style choice. there should be a strong, specific reason to write more than ~5 lines of bash in a command function — validation/defaulting/dispatch is never that reason.

## do not

- do not hand-validate a closed set of values in bash (`if [[ "$x" != "a" ...`). use inline choices `[a|b]` or a `_choice_*` function instead.
- do not manually check for missing/empty required args (`[[ -z "$1" ]] && exit 1`). use `!`/`+` modifiers on `@arg`/`@option`.
- do not write `${argc_x:-default}` fallback logic. use `=value` or `` =`_default_fn` `` in the tag.
- do not hand-roll env var presence/choice checks (`: "${var:?}"`, `[[ -z "$var" ]]`). use `@env name!`, `@env name=default`, `@env name[choice|choice]`.
- do not hand-roll a `command -v tool || exit` block per dependency. use one `@meta require-tools tool,...`.
- do not manually `shift`/slice `"$@"` for pass-through args. use the rest-of-args notation `<args+>` on the last `@arg`/`@option`.
- do not write an if/case dispatch to let one parameter constrain another's valid values. use `@meta symbol` plus a choice function that reads the earlier `argc_*` var.
- `_choice_*` functions are pure value emitters (one value per line, or `value<tab>description`) — not decision trees. if a choice list already exists as a function, call it; don't re-derive the same list inline elsewhere.
- never `chmod +x` an argc script. always invoke via `argc <task>` or `argc --argc-run ./script.sh`.
- the `eval "$(argc --argc-eval "$0" "$@")"` line is infrastructure, not part of the "5 lines" budget — every script needs exactly this one line, nothing more.
- when unsure what argc will generate for a given tag, run `argc --argc-eval` and read the generated bash rather than writing defensive code "just in case."
