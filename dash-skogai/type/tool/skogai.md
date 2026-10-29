---
type: tool
title: skogai
---

# skogai

the cli that turns dash into a dot. it is a function over values: `check` and `plan` are pure, and `apply` is the only writer.

## values

- **dash**: type definitions and functions, named by ref and resolved to a commit at use.
- **layers**: `base` (dash@ref), `global` (`~/.skogai`), `local` (`<repo>/.skogai`). key/value settings use [skogai-config](../../bin/skogai-config.md).
- **resolved**: `fold(merge, [base, global, local])`, later layer wins.
- **dot**: the resolved value written to disk, a closed union of skogai types.

## commands

### `skogai config`

implemented in `bin/skogai-config`, run as `argc config`. see [skogai-config](../../bin/skogai-config.md).

### `skogai check [<dot>]`

pure. reports type errors, writes nothing.

1. runs `okn validate` on the dot.
2. every file has exactly one owner (see [type](../type.md#check)).
3. every `type` tag is a case dash defines, and the file has that case's `fields`.
4. every derived file equals its regeneration.

prints the dash ref and the commit it resolved to.

### `skogai resolve [<dot>]`

pure. prints the resolved value, and for each entry the layer it came from.

### `skogai plan [<dot>]`

pure. prints the patch `apply` would make, as a git diff. an empty patch means the dot is already up to date.

### `skogai apply [<dot>] [<patch>]`

the only writer. applies `<patch>`, or the output of `plan` if none is given, with `git apply`.

- idempotent: after `apply`, `plan` is empty.
- init is `apply` on an empty dot.
- moving to a newer dash is changing the ref, then `plan` and `apply`.

## conventions

- `<dot>` defaults to `./.skogai`.
- output goes to stdout, diagnostics to stderr.
- exit `0`: clean or empty patch. `1`: type errors or a non-empty patch. `2`: usage or internal error.
- `--json` on every command, for machine output.
- anything okn already does (list, search, view, validate) is called through okn, not rebuilt.

## open

see [TODO](../../TODO.md): where the dash ref is recorded, merge semantics per field, and how a type declares a derived file.
