---
type: decision
title: root DECISIONS.md routes into .skogai, it does not hold decisions
description: resolves whether decisions live at the repo root or under .skogai/knowledge/decisions/
tags: [decision,router]
status: stable
generated: { by: "user:skogix"}
permalink: decision/0002-root-decisions-file
---

# proposal

Before `.skogai/knowledge/decisions/` existed, a flat `DECISIONS.md` was
drafted at the repo root, using a `### Dn`/`On`/`Tn` heading scheme
reverse-engineered (via a herdr-dispatched agent in `projects/skogai-cli`)
from that submodule's own `docs/DECISIONS.md`. Its first entry, D1, asked
the same question `0001-types.md` in this directory answers: what a
decision is.

# context

For a short time both existed side by side: the flat root file (its own
schema, `Dn`/`On`/`Tn` IDs, no frontmatter) and this per-file,
OKF-frontmatter directory (filename numbering, `type: decision`). Keeping
both would mean maintaining two incompatible ID/status schemes and
manually syncing whichever decisions got written into one but not the
other — the "no external source of truth" problem, recreated inside this
repo's own decision records.

# decision

`.skogai/knowledge/decisions/` is the one place decisions get recorded.
Root `DECISIONS.md` is reduced to a router pointing at
`.skogai/knowledge/DECISIONS.md`, the same pattern already used by
`AGENTS.md -> @SKOGAI.md` at the repo root.

# consequences

- D1's content, translated into this schema, became decision 0001
  (`0001-types.md`); its reflexive framing ("the first decision is the
  definition of what a decision is") carries over unchanged.
- Root `DECISIONS.md` has no decision content of its own going forward;
  it only routes.
- Per-project decision files elsewhere (e.g.
  `projects/skogai-cli/docs/DECISIONS.md`) are untouched by this —
  whether they migrate to this schema too is a separate, not-yet-made
  decision.

# routes

- @0001-types.md

- this all should be discussed more and probably renamed/moved before becoming a proposal. it is all correct but simply to early.
