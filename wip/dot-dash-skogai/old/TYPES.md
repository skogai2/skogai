# Types — summary

Draft summary, 2026-10-11. **No skogai type is defined yet.** dash-skogai's
`knowledge/types.md` (from workorder 0020) only names types. Decision 0007
says the set is open, and OKF §4.1 makes `type` a free-form string that
nobody registers centrally. The entries below say what each type is *for*,
where it is defined (if anywhere), and where it is only mentioned.
Following [concepts-not-mechanisms](../.skogai/memory/concepts-not-mechanisms.md),
they describe concepts, not the tools that implement them.

Shorthand: **dash types.md / glossary.md / layout.md** =
`~/.local/src/dash-skogai/knowledge/{types,glossary,layout}.md` (published as
`/skogai/knowledge/`, outside this repo).

## skogai's own types

### type

The concept of a type itself: what a type is, and what every type
definition has to state. Step 1 of the ground-up order says that
everything after it is a type. **Undefined.** In OKF, `type` is the one
required frontmatter key, with free-form values (SPEC §4.1). Decision 0007
says new types need no format change.
Mentioned: [ground-up-order.md](ground-up-order.md),
[0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
[SPEC.md §4.1](../.skogai/knowledge/SPEC.md).

### router

A file that routes instead of teaching: it links to, references or injects
the context it owns. It is how anything is found, and the only skogai type
already in use. **Defined in dash glossary.md (draft); listed "name only" in
dash types.md.** It is used as `type: router` in `AGENTS.md`, `SKOGAI.md`,
`.skogai/{SKOGAI,ROUTES,AGENTS,CLAUDE}.md`. `ROUTES.md` has an empty
`# types / ## router` placeholder.
Mentioned: [ROUTES.md](../.skogai/ROUTES.md),
[ground-up-order.md](ground-up-order.md) (step 2).

### decision

A past, closed choice, with who decided and why (skogix's older schema,
a candidate only). In 0007 it is local knowledge. **Undefined as a skogai
type.** In use as `type: Decision` on 7 pages, with the conventions set by
0001 and the OKF `decisions` maintenance rule.
Mentioned: [decisions/](../.skogai/knowledge/decisions/index.md),
[0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
dash types.md, [ground-up-order.md](ground-up-order.md) (step 3).

### principle

A defeasible axiom, always in scope until someone argues it out of place
(candidate). It is global knowledge, reached by promoting a pattern that
holds everywhere. **Undefined.** In use as `type: Principle` on one staged
page; skogix calls that page "an instance of a principle", which is too
early to move. Two memories are candidate principles.
Mentioned: [write-commit-push.md](../.skogai/knowledge/principles/write-commit-push.md),
[0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md), dash types.md.

### pattern

A recurring "do it like this", timeless, built up from repetition
(candidate). It is global knowledge, and the step between recurring memory
and principle. **Undefined; no instances.**
Mentioned: [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
dash types.md, [ground-up-order.md](ground-up-order.md).

### list

Append-only entries where position carries meaning (candidate). Global
memory is described as "an append-only list", and so is "action".
**Undefined; no `type: list` instances.**
Mentioned: [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
dash types.md, dash glossary.md.

### event

One entry in global memory: shared once, to be acted on, never edited.
Readers keep their own read-marker. **Defined as a term in dash
glossary.md; "name only" in dash types.md. No instances** (`/skogai/memory/`
does not exist yet).
Mentioned: [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
[ground-up-order.md](ground-up-order.md).

### rule

A skogfence: enforcement by structure, so that the forbidden option does
not exist. It is explicitly *not* knowledge; a page may describe a fence
but never stands in for one. **Glossary term; "name only" in dash
types.md.** Conflict: OKF uses "rules" for something unrelated (the
`[rules]` maintenance rules and the `Agent Rules` type below).
Mentioned: [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md).

### trigger

The moments something reacts to, as concepts: *on change*, *session
start*, *session end*, *before merge*. **Undefined; proposed only** as
step 4. Not listed in dash types.md.
Mentioned: [ground-up-order.md](ground-up-order.md),
[knowledge-definitions.md](knowledge-definitions.md) (which still names
mechanisms).

### tool

What a tool offers, which triggers it reacts to, and which files it
touches, split into files it owns and files it only points at. A tool may
own a named slice of several `.skogai/` directories (the `wt` example).
**Undefined; "name only" in dash types.md** (`type: tool; name: wt`).
Mentioned: dash layout.md, [ground-up-order.md](ground-up-order.md) (step 5),
[offer-dont-install.md](../.skogai/memory/offer-dont-install.md).

### workorder (also "action", "raw layer")

The unit of work one worker implements, and the immutable record of it
once landed. **Undefined, and the name is open.** Three names are in use
for the same place: "workorder" (0002, with `status: open|done|blocked`),
"raw layer" (0004), and "action" (0007's expiry outcome, the 0020 layout
draft). Workorder files carry no `type:` field.
Mentioned: [0002](../.skogai/knowledge/decisions/0002-orchestration-model.md),
[0004](../.skogai/knowledge/decisions/0004-knowledge-lifecycle.md),
dash glossary.md, [ground-up-order.md](ground-up-order.md) (step 6).

### knowledge / memory

These are the two lifespans in 0007 (knowledge lasts, memory expires),
crossed with global and local scope. Step 3 calls them a group whose
"types" are principle, pattern, decision, list and event, so they read as
categories of types rather than types. **Terms defined in dash
glossary.md; not defined as types.** Local memory entries use
`name/description/created/stale_after` and have no `type:` field.
Mentioned: [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md),
[memory/index.md](../.skogai/memory/index.md).

### layout

The one `.skogai/` directory tree, of which every dot-skogai is an
instance. Step 7 says it is "not decided separately": each directory is
just where a type lives. **Conflict:** dash layout.md already carries
`type: Layout` (draft).
Mentioned: [ground-up-order.md](ground-up-order.md), dash layout.md.

## Types in use without a skogai definition

### Repository

One page per skogai2 repo, giving its role, state and workorder caveats.
**Used on 15 pages in `repos/`; defined nowhere** and not named in dash
types.md.
[repos/index.md](../.skogai/knowledge/repos/index.md).

### Agent Rules

The rules for agents working inside the bundle. **Generated by
openknowledge scaffold; defined nowhere in skogai.**
[AGENTS.md](../.skogai/knowledge/AGENTS.md).

### Open Knowledge Insight

A draft observation produced at the end of a session (`status: draft`,
`okf_publish: false`). The memory note says these are local memory sitting
inside the knowledge bundle, untriaged. Where they should live is
undecided. **Defined by openknowledge, not skogai.** 3 instances.
[insights/](../.skogai/knowledge/insights/),
[openknowledge-insights-are-memory.md](../.skogai/memory/openknowledge-insights-are-memory.md).

### Specification

The pinned local copy of the OKF spec. 1 instance.
[SPEC.md](../.skogai/knowledge/SPEC.md).

### Glossary, Reference (dash-skogai)

These are the types on dash glossary.md and dash types.md. **Defined
nowhere.** dash types.md is `type: Reference` even though it is skogai's
type list.

## OKF spec examples only

`BigQuery Table`, `BigQuery Dataset`, `API Endpoint`, `Metric`, `Playbook`,
`Reference` and `Attested Computation` appear as example values in
[SPEC.md](../.skogai/knowledge/SPEC.md) (§4.1, §10). Only `Attested
Computation` carries spec-defined meaning (§10). None is used in skogai,
except `Reference` in dash-skogai.

## Conflicts and gaps

- **Casing.** `router` is lowercase; `Decision`, `Principle`, `Repository`
  are capitalized; dash types.md writes all of them lowercase.
- **Status.** Pages carry `type: Decision`/`Principle` although those types
  are formally undefined.
- **Undefined in use.** `Repository`, `Glossary`, `Layout` and `Reference`
  are used but appear in no type list.
- **No `type:` field.** Memory entries and workorders have none, although
  0007 and the ground-up order treat them as typed.
- **One place, three names.** workorder / action / raw layer.
- **"rule".** skogai's skogfence meaning collides with OKF's maintenance
  "rules" and `Agent Rules`.
- **Not a type?** layout: step 7 says it is not a separate type, yet a
  `type: Layout` page exists.
- **Mechanisms in definitions.** The current dash pages still name
  mechanisms (`wt` in layout.md's tool slice, `git` for logs/worktrees),
  which the concepts-not-mechanisms memory wants removed.
