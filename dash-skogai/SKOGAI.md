# routes 

- @src/index.md
- @type/index.md

# layout

- `./`: meta, how we work on dash (CLAUDE.md, SKOGAI.md, TODO.md)
- `type/`: one file per type, each acting as a module
- `src/`: the future dot, an okn bundle. check with `okn validate src`
- `tmp/`: untyped or undecided

# design goals

skogai is functional: idempotent, immutable and strictly typed.

- **closed union**: a dot is a discriminated union of skogai types. okf `type` is the tag, dash defines the cases, and an unknown tag or untagged file is a type error.
- **layers, not inheritance**: the resolved state is `fold(merge, [base, global, local])`, later layer wins. no layer knows about the others.
- **git is the immutability model**: content is immutable, a change is a patch, history is the append-only log. types do not declare mutability.
- **refs resolve to commits**: a dot names dash by ref. every result reports the commit it resolved to, so it can be reproduced.
- **generated where possible**: a file derived from others (e.g. `DECISIONS.md`) is never hand-edited, and `check` regenerates and compares it.
- **pure by default**: only `apply` writes. see [skogai](type/tool/skogai.md).
- **don't rebuild okn**: list, validate, search and the rest belong to [okn](type/tool/okn.md).

# handover

## how to work here

- listen to what skogix says. he is probably saying it for a reason.
- one thing at a time. when proposals, plans, extra steps and questions should be added to TODO.md to be managed with the focus and attention they deserve.
- understand what the intent, goal and actual changes needed are before running anything.

