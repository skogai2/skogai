---
type: index
corpus_schema:
  version: "1"
  document_types:
    - id: draft
      paths: ["*.md"]
      required: [title]
    - id: tool
      paths: ["tools/**"]
      required: [title]
---

# src

the future dot: authored source that `apply` turns into a `.skogai`.
