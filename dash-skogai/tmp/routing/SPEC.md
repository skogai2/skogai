# skogai-routing spec

status: draft, concept only. written 2026-11-07 from the v1 `skogai-routing` skill (this folder), with the implementation details removed. read [README.md](README.md) first for the idea; this file is the contract a new implementation is built and tested against.

MUST, SHOULD and MAY are used as in RFC 2119. every MUST is meant to be a check. items marked **(proposed)** generalize past what v1 did and need a decision before they bind (see [open](#open)).

## 1. terms

- **document**: a markdown file with frontmatter (state) and a body (text).
- **tag**: the frontmatter `type` of a document.
- **root block**: an xml element in the body whose name is fixed by the tag.
- **router**: a document with tag `router`. it points to other paths and holds no content.
- **entry**: one line of a router's root block, naming one target.
- **target**: the path an entry names: a file, a folder, or a permalink.
- **eager entry**: an entry the host loads together with the router (`@target`).
- **lazy entry**: an entry that is only listed. an agent reads the target when the task needs it.
- **host**: the agent runtime that loads files (claude code, codex, ...). routing defines documents; the host does the loading.
- **shim**: a file the host loads by itself (`CLAUDE.md`, `AGENTS.md`), whose whole job is to point at the entrypoint.
- **entrypoint**: the first router a shim points at.
- **chain**: the graph of routers reached from an entrypoint by following entries.
- **eager closure**: everything that loads when a document loads: the document, plus the eager closure of each of its eager targets.

## 2. document shape

1. a router MUST have frontmatter with `type: router`.
2. its body MUST contain exactly one root block, `<routes>`, with no attributes. the opening and closing tags MUST each be on their own line.
3. prose and fenced examples MAY appear before or after the root block. no other xml block is allowed.
4. **(proposed)** the rule generalizes to every type: the tag names the root block, one tag pairs with one block name. a document of a type with a defined block MUST have exactly that one block.

## 3. entries

```text
entry       := "- " target [ " - " description ]
target      := [ "@" ] ( path | folder | permalink )
folder      := path ending in "/"
```

1. every nonblank line inside `<routes>` MUST be an entry. blank lines MAY appear.
2. `@` makes an entry eager. without `@` it is lazy.
3. a relative target resolves from the router's own folder.
4. every target MUST resolve to something that exists. a dangling target is an error.
5. a lazy entry SHOULD have a description. it is what lets an agent decide whether to read the target without opening it.
6. an eager folder target lists the folder and permits reading the files in it. it does not load them.

## 4. roles

a router plays one of two roles. the role decides what it may load eagerly.

- **router** (routing role): points to the next level. stays small (SHOULD stay under ~30 lines).
- **loader** (content role): a leaf. it eagerly loads all of its content, because loading that content is why anyone enters it.

an **index** is a small router whose body is a short list or table (a type list, a name table). it counts as a router.

**(proposed)** the role is declared, e.g. `role: loader` in frontmatter, instead of being inferred from what a document links.

## 5. loading rules

1. **no transitive bloat.** the eager closure of a router in the routing role MUST contain only routers and indexes. a router MUST NOT eagerly load a loader or a content file. it lists them lazily instead.
2. **one step.** a router points to the next level of the chain, never past it to everything below.
3. **no eager cycles.** if a document is in its own eager closure, that is an error. lazy cycles are allowed.
4. **minimal default.** if a canonical entrypoint already surfaces every route, the shim needs nothing else. routes for things that don't exist yet MUST NOT be added.
5. eager loading is a request to the host, not a guarantee. the host may truncate or drop content under its own limits (see [§9](#9-host-binding-claude-code)).

## 6. shims and the entrypoint

1. a shim MUST contain exactly one eager entry and nothing else. it is derived, never hand-edited.
2. current convention (decided 2026-11-06, `.skogai/rules/agents-md.md`): `CLAUDE.md` is `- @AGENTS.md`, and instructions live in `AGENTS.md`.
3. **(proposed)** `AGENTS.md` is itself a shim for hosts that load it natively, and points at `SKOGAI.md`, the entrypoint. dash-skogai already does this (`CLAUDE.md` → `AGENTS.md` → `SKOGAI.md`); the repo root does not (its `AGENTS.md` holds content).
4. the check regenerates every shim and compares (same as any derived file).

## 7. reachability (proposed)

1. every document in scope SHOULD be the target of some entry in the chain, eager or lazy. an unreachable file is invisible to an agent that only follows routes.
2. this sits next to ownership: ownership says who may write a file (exactly one owner), reachability says who can find it. a file can satisfy one and not the other.
3. what is "in scope" (every tracked `.md`? only typed documents?) is open.

## 8. permalinks (proposed)

1. a permalink is `repo/name`: a logical id, not a filesystem path. `repo` names a logical repo, project or concept.
2. it resolves to the first of these that exists:
   1. `$HOME/<repo>/<name>.md`
   2. `$HOME/.local/src/<repo>/<name>.md`
   3. `./projects/<repo>/<name>.md` (a project inside a monorepo, treated as its own future repo)
3. a permalink MUST stay the same when the repo moves between these places. this is what keeps routes alive through moves like dash-skogai → skogai-runner.
4. no match is an error. **(open)** more than one match: first wins, or ambiguity error?
5. a permalink names a location, not a version. to reproduce a result, the check MUST also report the commit each permalink resolved to (skogai's "refs resolve to commits").

## 9. host binding: claude code

routing does not implement loading. this is what the claude code host does with the shapes above, recorded so checks can model it. it is observed behavior, not contract.

- `@path` in a loaded file is expanded from the real filesystem when the file is loaded, up to about six levels deep.
- an `@` link also grants read permission for that path. a subagent cannot read a path that was never linked, and it gets no error saying so. a message to a subagent should eagerly link every file the subagent needs.
- only literal paths: `@a`, `@./`, `@~/`, `@/`. no globs.
- resolution is relative to the file being read.
- claude code natively loads `CLAUDE.md`, never `SKOGAI.md`. in this workspace `AGENTS.md` is reached through the `CLAUDE.md` shim. that is why shims exist.

## 10. operations

the concept needs these operations, and nothing in it needs more. which tool hosts them is an implementation choice; okn is used for anything it already does.

| operation | input | output | writes |
| --- | --- | --- | --- |
| discover | a root folder | every document tagged `router` under it | no |
| check | documents, or a root folder | findings (§11) | no |
| graph | an entrypoint | the chain: nodes, eager and lazy edges, roles | no |
| scaffold | a folder | a new router and its shim | yes, the only writer |

- discover reads frontmatter only. a file with no or broken frontmatter is skipped, not an error.
- check on an explicitly named file fails closed: missing frontmatter, another tag, or a bad body is an error.
- scaffold MUST NOT overwrite an existing router or shim. it writes an empty `<routes>` block and invents no entries. it then runs check on what it wrote and reports the result.

## 11. findings

a finding is `{ level, path, kind }`, the same shape as the dash `check`. `level` is `error` or `warning`.

| kind | level | rule |
| --- | --- | --- |
| `untagged` | error | §2.1 (only for explicitly named files) |
| `missing root` / `extra block` | error | §2.2, §2.3 |
| `block attributes` | error | §2.2 |
| `bad entry` | error | §3.1 |
| `dangling` | error | §3.4 |
| `no description` | warning | §3.5 |
| `bloat` | error | §5.1, naming the loader or content file pulled in |
| `eager cycle` | error | §5.3 |
| `shim drift` | error | §6.1 |
| `unreachable` | warning | §7.1 |
| `permalink unresolved` | error | §8.4 |

exit codes follow skogai: `0` clean, `1` findings at error level, `2` usage or internal error.

## 12. non-goals

- loading. the host loads; routing only defines and checks.
- other document types from the v1 schemas (`lesson`, `workflow`, `template`, `reference`). no second type is added until one is concretely needed.
- skill mechanics (`!`command`` output blocks, `allowed-tools`).
- normalizing headings into sections. v1's `document.schema.json` let `## Purpose` stand in for `<objective>`; routing needs only the one root block.

## 13. what v1 got wrong (do not carry over)

- `router.schema.json` requires `objective` and `routing` sections, which contradicts the `<routes>` shape.
- the schemas `$ref` each other by relative id, so the validator fails with `Unresolvable: document.schema.json`.
- v1 put `permalink` on routers; dash names instances by `title`. a document needs one identity field (see open).
- dash's draft `type/router.md` says the shim is `@SKOGAI.md`; the 2026-11-06 rule made it `@AGENTS.md`.

## open

1. type tag = root block for every type (§2.4), or routers only?
2. role declared in frontmatter (§4), or inferred from links?
3. `AGENTS.md` as a shim to `SKOGAI.md` (§6.3), and the repo root brought in line?
4. reachability (§7): adopt, and what is in scope?
5. permalinks (§8): adopt, ambiguity rule, and is identity `permalink` or `title`? does it belong to a `repo` type?
6. home: does routing become a type in skogai-runner's markdown+, or stay a separate tool? (decision 0006 kept it out of dash until the type layer works.)
