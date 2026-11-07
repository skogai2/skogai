# routing

an agent has a finite context. routing decides what it loads, using the files themselves: progressive disclosure over the filesystem.

the contract is [SPEC.md](SPEC.md). this page is the idea.

## the idea

- **a router points.** a line beginning with `- @` is a link: the host loads the target together with the router. everything else in the body is prose.
- **links are transitive.** a linked file's own links load too, so every link is paid for by every session that passes through. a router stays short and links one step down.
- **each level points one step down.** a host loads a shim (`CLAUDE.md`), the shim points at an entrypoint, the entrypoint points at the next level. no level tries to be complete.
- **identity survives moves.** a router names itself by permalink, `repo/name`, which resolves wherever the repo is checked out. links stay real paths, because that is all the host can expand.
- **the shape is checkable.** frontmatter `type: router` plus the `- @` prefix is enough for a tool to find every router, check every link resolves, catch cycles, and verify every permalink points back at its document.

## how it fits skogai

- it is markdown+: frontmatter is state, the body is text.
- the chain is a fold like the config layers, global → workspace → area → leaf, each level adding to what is loaded.
- shims are derived files: generated, never hand-edited, compared by the check.

## what is here

the v1 `skogai-routing` skill, moved from `~/skogix/.projects/routing` (skogix `31050be`); the older seed is `~/.local/src/skogai-routing`. SPEC.md is distilled from it. the rest is kept as source material, not as the implementation to keep:

- `SKILL.md`, `references/`, `examples/`: the skill as it was. `references/at-linking.md` is the source for the claude code host binding (SPEC §6). `references/claude-md-routing-rules.md` holds v1's router/loader split, which the spec dropped.
- `schemas/`: v1 json schemas. broken and partly contradicting the spec, see SPEC §11.
- `scripts/`: v1 python validators and listers.

dash's draft [type/router.md](../../type/router.md) was folded from the same source and predates the spec.
