# skogai-routing spec

status: draft, concept only. written 2026-11-07 from the v1 `skogai-routing` skill (this folder), with the implementation details removed, then narrowed by skogix's answers the same day. read [README.md](README.md) first for the idea; this file is the contract a new implementation is built and tested against.

MUST, SHOULD and MAY are used as in RFC 2119. every MUST is meant to be a check.

## 1. terms

- **document**: a markdown file with frontmatter (state) and a body (text).
- **tag**: the frontmatter `type` of a document.
- **router**: a document with tag `router`. it points to other paths.
- **link**: a body line that begins with `- @`. it names one target.
- **target**: the path a link names: a file or a folder.
- **host**: the agent runtime that loads files (claude code, codex, ...). routing defines documents; the host does the loading.
- **shim**: a file the host loads by itself (`CLAUDE.md`, `AGENTS.md`), whose whole job is to point at the entrypoint.
- **entrypoint**: the first router a shim points at.
- **chain**: the graph of documents reached from an entrypoint by following links.
- **closure**: everything that loads when a document loads: the document, plus the closure of each of its targets.

## 2. document shape

1. a router MUST have frontmatter with `type: router` and a `permalink` (§5).
2. the body is free markdown. only links (§3) carry meaning for routing; every other line is prose.

## 3. links

```text
link        := "- @" target [ " - " description ]
target      := path | folder
folder      := path ending in "/"
```

1. a line is a link if and only if it begins with `- @`. nothing else is parsed: no enclosing block is required, and a bullet without `@` is prose, not a route.
2. a relative target resolves from the document's own folder.
3. every target MUST resolve to something that exists. a dangling target is an error.
4. a target is a filesystem path, never a permalink: the host expands only real paths (§6).
5. a folder target lists the folder and permits reading the files in it. it does not load them.
6. a link SHOULD have a description, so a reader knows what is there without opening it.

## 4. loading rules

1. **links are transitive.** a link loads its target, and the target's links load too. the closure of a document is what every session that loads it pays for.
2. **one step.** a router SHOULD point to the next level of the chain, never past it to everything below.
3. **no cycles.** if a document is in its own closure, that is an error.
4. **minimal default.** if the entrypoint already surfaces every route, the shim needs nothing else. links to things that don't exist yet MUST NOT be added.
5. loading is a request to the host, not a guarantee. the host may truncate or drop content under its own limits (§6).

a closure has no bound and routers have no roles: any document may link anything (v1's "router vs content-loader" split and its no-bloat rule are dropped).

## 5. permalinks

1. a document's identity is its `permalink`: `repo/name`, a logical id, not a filesystem path. `repo` names a logical repo, project or concept.
2. it resolves to the one of these that exists:
   1. `$HOME/<repo>/<name>.md`
   2. `$HOME/.local/src/<repo>/<name>.md`
   3. `./projects/<repo>/<name>.md` (a project inside a monorepo, treated as its own future repo)
3. a permalink MUST stay the same when the repo moves between these places. this is what keeps a document's identity through moves like dash-skogai → skogai-runner.
4. a permalink that resolves to nothing is an error. one that matches more than one location is an error too: no location wins by order.
5. a permalink MUST resolve back to the document that declares it. a mismatch (two documents claiming one permalink, or a permalink resolving to another file) is an error.
6. a permalink names a location, not a version. to reproduce a result, the check MUST also report the commit each permalink resolved to (skogai's "refs resolve to commits").

## 6. host binding: claude code

routing does not implement loading. this is what the claude code host does with the shapes above, recorded so checks can model it. it is observed behavior, not contract.

- `@path` in a loaded file is expanded from the real filesystem when the file is loaded, up to about six levels deep.
- an `@` link also grants read permission for that path. a subagent cannot read a path that was never linked, and it gets no error saying so. a message to a subagent should link every file the subagent needs.
- only literal paths: `@a`, `@./`, `@~/`, `@/`. no globs, no permalinks.
- resolution is relative to the file being read.
- claude code natively loads `CLAUDE.md`, never `SKOGAI.md`. in this workspace `AGENTS.md` is reached through the `CLAUDE.md` shim. that is why shims exist.

## 7. shims and the entrypoint

1. a shim MUST contain exactly one link and nothing else. it is derived, never hand-edited.
2. `CLAUDE.md` is `- @AGENTS.md` (decided 2026-11-06, `.skogai/rules/agents-md.md`).
3. `AGENTS.md` is `- @SKOGAI.md`, for hosts that load `AGENTS.md` natively (decided 2026-11-07). `SKOGAI.md` is the entrypoint. so every folder with instructions has the chain `CLAUDE.md` → `AGENTS.md` → `SKOGAI.md`.
4. the check regenerates every shim and compares (same as any derived file).

## 8. operations

the concept needs these operations, and nothing in it needs more. which tool hosts them is an implementation choice; okn is used for anything it already does.

| operation | input | output | writes |
| --- | --- | --- | --- |
| discover | a root folder | every document tagged `router` under it | no |
| check | documents, or a root folder | findings (§9) | no |
| graph | an entrypoint | the chain: nodes and links | no |
| scaffold | a folder | a new router and its shim | yes, the only writer |

- discover reads frontmatter only. a file with no or broken frontmatter is skipped, not an error.
- check on an explicitly named file fails closed: missing frontmatter or another tag is an error.
- scaffold MUST NOT overwrite an existing router or shim. it invents no links. it then runs check on what it wrote and reports the result.

## 9. findings

a finding is `{ level, path, kind }`, the same shape as the dash `check`. `level` is `error` or `warning`.

| kind | level | rule |
| --- | --- | --- |
| `untagged` | error | §2.1 (only for explicitly named files) |
| `no permalink` | error | §2.1 |
| `dangling` | error | §3.3 |
| `no description` | warning | §3.6 |
| `cycle` | error | §4.3 |
| `permalink unresolved` | error | §5.4 |
| `permalink ambiguous` | error | §5.4 |
| `permalink mismatch` | error | §5.5 |
| `shim drift` | error | §7.1 |

exit codes follow skogai: `0` clean, `1` findings at error level, `2` usage or internal error.

## 10. out of scope

- loading. the host loads; routing only defines and checks.
- a root xml block per type (v1's `<routes>`, and "the tag names the block" for every type). links are found by the `- @` prefix alone for now.
- lazy entries: listing a path without `@` is prose, not a route.
- roles and closure bounds (router vs loader, no-bloat).
- where routing lives (a markdown+ type in skogai-runner, or a separate tool). decision 0006 kept it out of dash until the type layer works.
- reachability ("every file is listed by some router").
- other document types from the v1 schemas (`lesson`, `workflow`, `template`, `reference`).
- skill mechanics (`!`command`` output blocks, `allowed-tools`).

## 11. what v1 got wrong (do not carry over)

- `router.schema.json` requires `objective` and `routing` sections, which contradicts v1's own `<routes>` shape.
- the schemas `$ref` each other by relative id, so the validator fails with `Unresolvable: document.schema.json`.
- dash's draft `type/router.md` says the shim is `@SKOGAI.md`; the 2026-11-06 rule made it `@AGENTS.md`.

## decided 2026-11-07

- a link is a line beginning with `- @`; no root block.
- identity is `permalink` (`repo/name`).
- no roles, no closure bound.
- reachability is out of scope.
- a permalink matching more than one location is an error.
- `AGENTS.md` is a shim to `SKOGAI.md` everywhere.
- where routing lives is out of scope.
