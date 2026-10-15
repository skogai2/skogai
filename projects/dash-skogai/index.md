---
okf_version: "0.2"
okf_bundle_name: "dash-skogai"
okf_bundle_purpose: "Defines the closed set of skogai types that every .skogai is checked against."
corpus_schema:
  version: "1"
  document_types:
    - id: Agent Rules
      paths: [AGENTS.md]
    - id: Specification
      paths: [SPEC.md]
    - id: Decision
      paths: [decisions/**]
      required: [title, description, status, generated]
---

# dash-skogai

Defines the closed set of skogai types. The types are the `corpus_schema` in
this file's frontmatter, so `okn validate` checks them.

* [Decisions](decisions/index.md) - one line each, newest first.
* [Agent rules](AGENTS.md)
* [Spec](SPEC.md) - pinned OKF spec.
* [Log](log.md)
