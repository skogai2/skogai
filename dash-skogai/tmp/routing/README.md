# routing

an agent has a finite context. routing decides what it loads up front and what it only knows exists, using the files themselves: progressive disclosure over the filesystem.

the contract is [SPEC.md](SPEC.md). this page is the idea.

## the idea

- **a router routes, it holds no content.** it is a short list of paths, each with a line saying what is there.
- **two ways to point.** `@path` loads the target together with the router. a plain path only lists it, and an agent reads it when the task needs it. choosing between them is the whole design.
- **each level points one step down.** a host loads a shim (`CLAUDE.md`), the shim points at an entrypoint, the entrypoint points at area routers, the area routers point at content. no level tries to be complete.
- **routers stay light, loaders are heavy.** a loader is a leaf that loads all of its content, because that content is why you enter it. a router lists loaders, it never loads them: one `@` to a loader would pull everything beneath it into every session that passes by.
- **the shape is checkable.** frontmatter `type: router` names the one `<routes>` block in the body, so a tool can find every router, check every entry resolves, and catch bloat and cycles before an agent pays for them.

## how it fits skogai

- it is markdown+: frontmatter is state, the body is text.
- the chain is a fold like the config layers, global → workspace → area → leaf, each level adding to what is loaded.
- reachability ("someone can find this file") sits next to ownership ("exactly one thing may write it").
- shims are derived files: generated, never hand-edited, compared by the check.

## what is here

the v1 `skogai-routing` skill, moved from `~/skogix/.projects/routing` (skogix `31050be`); the older seed is `~/.local/src/skogai-routing`. SPEC.md is distilled from it. the rest is kept as source material, not as the implementation to keep:

- `SKILL.md`, `references/`, `examples/`: the skill as it was. `references/at-linking.md` is the source for the claude code host binding (SPEC §9).
- `schemas/`: v1 json schemas. broken and partly contradicting the spec, see SPEC §13.
- `scripts/`: v1 python validators and listers.

dash's draft [type/router.md](../../type/router.md) was folded from the same source and predates the spec.
