---
type: type
title: decision
description: a choice and why it was made, written once.
fields: [type, title, status]
owns: [type/decision/<nnnn>-<name>.md]
writes: [DECISIONS.md]
---

# decision

a decision records a choice and why. it is written once and never edited.

- **status**: `proposed`, `accepted` or `superseded`.
- **supersedes**: optional, the number of the decision this one replaces.

to change a decision, write a new one that supersedes it. `DECISIONS.md` is derived from the instances and never edited by hand.
