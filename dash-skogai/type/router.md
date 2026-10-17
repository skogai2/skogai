---
type: type
title: router
description: a file that points to other files, so an agent loads only what the task needs.
status: draft
fields: [type, title]
owns: [<name>/SKOGAI.md]
---

# router

a router routes, it does not hold content. its body is one `<routes>` block: the frontmatter `type` names the block, as `router` names `<routes>`.

```markdown
---
type: router
title: dash-skogai
---

<routes>

- @type/index.md - small index, loaded with the router
- tmp/ - untyped or undecided, read when needed

</routes>
```

- **entries**: one per line, `- <path> [- <description>]`. the description lets an agent decide without opening the file.
- **`@path`**: loaded with the router. use it for small routers and indexes.
- **plain path**: listed, read on demand. use it for anything with real content.
- **no transitive bloat**: a router never `@`-links a file that itself `@`-links content. that loads everything below it.
- **one step**: each router points to the next level, never to everything.

`CLAUDE.md` is the only file claude code loads natively. it reaches a router by `@`-linking it.

the source this was folded from is [tmp/routing](../tmp/routing/README.md).
