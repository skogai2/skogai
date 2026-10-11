# decision — the first case definition

Draft, 2026-10-11. The first skogai type written as a case of the union
described in [model.md](model.md). It is derived from the seven decisions
in `.skogai/knowledge/decisions/`, skogix's older schema ("a past, closed
choice, with who decided and why"), and the OKF spec. Nothing here is
agreed yet.

## Definition

### Tag

`type: Decision`

### Fields

| Key | Required | Value | Meaning |
|---|---|---|---|
| `type` | yes | `Decision` | The discriminator. |
| `title` | yes | string | The choice, stated as a result. |
| `description` | yes | one sentence | What was chosen. Index lines are built from it. |
| `status` | yes | `draft` \| `stable` \| `deprecated` | `draft`: still open. `stable`: closed and in force. `deprecated`: closed and replaced. |
| `generated` | yes | `{ by: actor, at: datetime }` | Who wrote the page. |
| `verified` | yes when `stable` | one or more `{ by: actor, at: datetime }` | **Who decided.** |
| `sources` | no | list of `{ id, resource, title }` | What the decision was based on. |
| `tags` | no | list of strings | |
| `supersedes` | no | link to a decision | The decision this one replaces. |
| `superseded_by` | yes when `deprecated` | link to a decision | The decision that replaced this one. |
| `stale_after` | **not allowed** | | A closed choice does not expire. It is superseded. |

Actors and datetimes follow OKF (SPEC §7, §5): `human:<id>`,
`<producer>/<version>` or `process:<id>`, and ISO 8601 with a UTC offset.

### Body

Three sections, in this order:

1. `# Context`: the situation and the question that was open.
2. `# Decision`: what was chosen.
3. `# Consequences`: what follows from it, including what it closes.

### Place

`knowledge/decisions/NNNN-<slug>.md`, where `NNNN` is a four-digit number,
unique in the directory and one higher than the previous decision. A
decision is local knowledge (decision 0007).

### Changes

- A `draft` decision may change freely.
- A `stable` decision's `# Decision` section is not rewritten. A different
  choice is a new decision that names the old one in `supersedes`.
- The only changes to a `stable` decision are: adding a `verified` entry,
  and moving to `deprecated` with `superseded_by`.
- `status` never moves backwards.

### Derived

`knowledge/decisions/index.md` is computed from the decisions in the same
directory: one line per decision, newest first, in the form
`* [NNNN — <short title>](<file>)`.

## Examples

### A valid decision

```markdown
---
type: Decision
title: Push on land — wo land pushes to origin
description: A change counts only once it reaches origin, so wo land pushes both branches.
tags: [decision, orchestration]
status: stable
generated: { by: "claude-code/claude-opus-5-5", at: "2026-10-10T00:00:00Z" }
verified: { by: "human:skogix", at: "2026-10-10T00:00:00Z" }
---

# Context

Landed work stayed in local checkouts, which decision 0005 calls disposable.

# Decision

`wo land` pushes the target repo's default branch and skogai `master`.

# Consequences

- A landed workorder is durable.
```

### Value errors

What a check would report. The command does not exist yet, so the output
format is illustrative.

```
knowledge/decisions/0008-foo.md
  error  verified   required when status is stable
  error  body       missing section "# Consequences"
knowledge/decisions/foo.md
  error  place      file name does not match NNNN-<slug>.md
knowledge/decisions/0009-bar.md
  error  status     "accepted" is not one of draft | stable | deprecated
  error  stale_after  not allowed on a Decision
knowledge/decisions/index.md
  error  derived    differs from the index computed from 9 decisions
```

### A patch error

A patch that edits the `# Decision` section of a stable decision:

```
knowledge/decisions/0002-orchestration-model.md
  error  changes    "# Decision" of a stable decision is not rewritten;
                    write a new decision with supersedes: 0002
```

This case is real. Decision 0002 says workers run with `acceptEdits`, and
`bin/wo` now uses `auto`. Under this definition the fix is a new decision
that supersedes 0002, not an edit.

### Today's decisions against this definition

- 0001 and 0002 have `generated.by: human:skogix` and no `verified`. They
  would fail the `verified` rule.
- 0005 and 0007 have both keys and would pass.
- 0003, 0004 and 0006 were not checked for this draft.

## Open questions

1. **Who decided.** This draft reuses OKF's `verified` for "who decided".
   OKF defines `verified` as "confirmed against its sources", which is
   close but not the same. The alternative is a separate key such as
   `decided: { by, at }`. Reusing `verified` means `okn list` already
   shows an undecided decision as `[unverified]`.
2. **Must a human decide?** The draft accepts any actor, because the vision
   is agent-approved changes with a skogix veto.
3. **`stale_after`.** Decision 0007 says local knowledge "may carry
   `stale_after`". The draft forbids it on decisions only.
4. **Tag casing.** `Decision` matches the seven existing pages; dash's
   `types.md` writes `decision`.
5. **Options considered.** The `decisions` maintenance rule asks for
   "context, options, chosen path, and tradeoffs". No existing decision
   has an options section, so the draft does not require one.
6. **Numbering across layers.** `NNNN` is unique per directory. If
   decisions ever exist in more than one layer, the numbers collide.
