# dash and dot — the model

Draft, 2026-10-11. Written from a discussion between skogix and the
orchestrator. Nothing here is a recorded decision yet.

## In one paragraph

dash-skogai defines a closed set of types. A dot-skogai (any `.skogai/`) is
a tree in which every node is exactly one of those types. The state of a dot
is computed by applying ordered layers on top of each other. Every change is
a patch. The CLI checks a dot against the types, shows the patch that would
bring it in line, and applies that patch.

## Keywords

skogix: the design keywords are **functional, idempotent, immutable, strict
types**. The earlier wording, "dash is a singleton / template / class, dot
is the implementation / instance", was an analogy to get the point across,
because OOP is the more familiar vocabulary. It is not the design.

| Analogy (OOP) | Design (functional) |
|---|---|
| dash is a class or singleton | dash is a **value at a revision**: type definitions and pure functions |
| dot is an instance with fields | dot is a **tree of typed values** |
| constructor, then update | one function, `apply`, that gives the same result when repeated |
| inheritance (parent, child) | **layers**, applied in order |
| lenient checking | a **type checker**: an unknown or untagged node is an error |

## dot is a discriminated union of skogai types

skogix: "dot is more alike a discriminated union of skogai-types".

- The **discriminator** is the `type` key in a file's frontmatter. Open
  Knowledge Format (OKF) already requires it.
- Each skogai type is one **case** of the union: router, decision,
  principle, and so on.
- A dot is a tree of nodes. Every node is exactly one case.

`okn list` already prints the union, one node per line:

```
|-- AGENTS.md  router  AGENTS  [unverified, stable]
|-- ROUTES.md  router  ROUTES  [unverified, stable]
|-- todo.list  asset
`-- todo.md  concept document is missing YAML frontmatter
```

`router` and `asset` are cases. `todo.md` has no tag, so it is a type
error.

**What skogai adds to OKF is closing the union.** OKF leaves `type` as a
free-form string and tells consumers to tolerate unknown values (SPEC
§4.1). In skogai, dash defines the cases, and a tag that dash does not
define is an error. Strict types then mean three things:

1. every node has a tag,
2. the tag is a case that dash defines,
3. the node satisfies that case.

## Layers: base → global → local

State is resolved the way most env, config and settings systems do it.
The usual names are **layered** or **cascading** configuration, or
**overlay**. Written as a function:

```
resolve = fold(merge, [base, global, local])     # the later layer wins
```

Layers are ordered inputs to one pure function. No layer knows about the
others, so nothing inherits from anything. This replaces the earlier
question of whether `~/.skogai` is a parent or a peer of a repo's
`.skogai`: it is a layer.

In git terms, each layer is a patch, and the resolved state is the base
with the patches applied in order.

## Immutability is git's model

skogix: understanding what a diff or patch is, and what `git apply` means
deep down, is the point.

- Content is immutable. A change is a patch. History is the append-only log.
- A "maintained" memory entry is therefore fine: an edit is a new patch,
  not a mutation.
- Mutability is not something a type declares.

This also gives two kinds of type rule:

- a **value rule** looks at one node as it is now (required fields, body
  sections, place);
- a **patch rule** looks at a change (for example: a stable decision's
  text is not rewritten).

## A dot names dash by ref

A dot refers to dash the way `master` refers to a commit: the name follows,
and at any moment it resolves to one exact revision. Both "latest" and "a
commit" are true at once. A check reports the revision it resolved, so the
result can be reproduced.

## Source and derived (not settled)

Some files are written by hand or by an agent (**source**). Others are
computed from them and never edited directly (**derived**), so they can be
deleted and regenerated. Example from the todo list:
`knowledge/decisions/*.md → knowledge/decisions/index.md`.

Proposed: a type states which of its files are derived, so that a check can
regenerate them and compare. skogix has not confirmed this split.

## The CLI

| Command | Kind | Does |
|---|---|---|
| `skogai check` | pure | Returns the type errors of a dot against dash at a revision. |
| `skogai plan` | pure | Returns the patch that `apply` would make. |
| `skogai apply` | effect | Applies the plan. It is the only writer. An empty plan means nothing changes. |

Creating a new dot is `apply` on an empty one. Triggers and tools become
functions that run on an event and go through the same `plan` and `apply`.

`openknowledge` (the `okn` fork) already has `list`, `validate`, `check`
and `ast`. skogai should build only what is missing:

1. the closed union: the case definitions, and the check that every node
   is one of them;
2. the fold: resolving base → global → local;
3. `plan` and `apply`: patches over a dot.

`openknowledge` can already close the union and check tag, place and
required fields, through a `corpus_schema` block. That leaves value types,
body sections, patch rules and derived files for skogai. See
[README.md](README.md).

## What a case definition states

Proposed minimum, to be confirmed. [decision.md](decision.md) is the first
one written this way.

| Part | States |
|---|---|
| Tag | The `type` value that selects the case. |
| Fields | The frontmatter keys: required or not, and the type of each value. |
| Body | The required sections, in order. |
| Place | Where in the layout a node of this case may appear. |
| Changes | The patch rules. |
| Derived | The files computed from nodes of this case. |

Definitions name concepts, never mechanisms
([memory](../../.skogai/memory/concepts-not-mechanisms.md)). A case
definition says "is not rewritten", not which command enforces it.

## Open questions

1. **Source and derived.** Is this the right split, and does a type declare
   it?
2. **Layers.** What are `base`, `global` and `local` concretely? A guess:
   dash defaults, `~/.skogai`, `<repo>/.skogai`. Which node types merge
   across layers (config) and which never do (a decision)?
3. **Where definitions live.** One page per case in dash's
   `knowledge/types/`, written in the format they describe?
4. **Casing of tags.** `router` is lowercase today; `Decision`,
   `Principle` and `Repository` are capitalized.
5. **Where the CLI lives.** `bin/skogai` in dash, or a revived skogai-cli.
6. **Files outside the union.** `todo.list` is an `asset`. Is `asset` a
   case anyone may use, or does every file need a skogai type?
7. **Older wording.** Decisions 0005 and 0007 use "dot-skogai" for
   `~/.skogai` only, and 0007 splits "global state" from "tools". Both
   predate this model and need a superseding decision.
