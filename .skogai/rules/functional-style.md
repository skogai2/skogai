---
description: Functional-programmer style for scripts and tooling
priority: 0
---
- Prefer narrow, composable tools over large multi-purpose scripts.
- Favor the repo's algebraic `$`/`@` notation (see `NOTATION.md`) over ad hoc conventions when
  extending config or scripts.
- Write scripts to be fresh-clone-safe: no reliance on machine-local state that a new checkout
  wouldn't have.
