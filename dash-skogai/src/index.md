---
type: Index
corpus_schema:
  version: "1"
  document_types:
    - id: Draft
      paths: ["*.md"]
      required: [title]
    - id: Tool
      paths: ["tools/**"]
      required: [title]
---

# src

the future dot: authored source that `apply` turns into a `.skogai`.

# types

- [types](types.md)

# tools

- [herdr](tools/herdr.md)
- [wt (worktrunk)](tools/wt.md)
- [gita](tools/gita.md)
- [mise](tools/mise.md)
- [okn (openknowledge executable)](tools/okn.md)
