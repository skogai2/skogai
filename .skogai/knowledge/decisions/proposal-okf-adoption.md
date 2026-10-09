---
type: decision
title: follow Open Knowledge Format when possible
description: adopt OKF as the default format for structured knowledge in this repo; scope not yet worked out
tags: [decision, okf, proposal]
status: draft
generated: { by: "human:skogix" }
permalink: decision/proposal-okf-adoption
---

# proposal

Follow the Open Knowledge Format (OKF) when possible for structured
knowledge written in this repo — decisions, and other knowledge files
under `.skogai/knowledge/` and elsewhere.

# context

- `0001-types.md` already leans on OKF for the decision-file schema
  itself (frontmatter fields, `index.md` vs a hand-rolled `DECISIONS.md`,
  etc.) but treats it as open discussion, not settled.
- `projects/ofk-claude/.okf/` already exists as a working OKF bundle
  elsewhere in this repo — precedent for the format, not yet a
  repo-wide rule.
- Raised 2026-10-09 as a rapid-fire one-liner, intentionally left
  unnumbered: the general principle is agreed, the scope (which files,
  how strictly "when possible" is read) is not yet worked out.

# decision

Not yet made. This file exists so the principle isn't lost while the
basics get built — promote it to a numbered decision once scope is
worked out.

# routes

- @0001-types.md
- projects/ofk-claude/.okf/ - existing OKF bundle in this repo
