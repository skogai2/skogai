---
okf_version: "0.2"
okf_bundle_name: "skogai"
okf_bundle_purpose: "Structured knowledge for the skogai repo: routing, decisions, and project context."
corpus_schema:
  version: "1"
  document_types:
    - id: Decision
      aliases: [decision]
      paths: ["decisions/**"]
      required: [title, description, status, generated]
    - id: Principle
      paths: ["principles/**"]
      required: [title, description, status, generated]
    - id: Repository
      paths: ["repos/**"]
      required: [title, description, generated, stale_after]
    - id: Open Knowledge Insight
      paths: ["insights/**"]
      required: [title, description, status, generated]
    - id: Specification
      paths: ["SPEC.md"]
      required: [title, description, generated]
    - id: Agent Rules
      paths: ["AGENTS.md"]
      required: [title, description, generated]
  link_predicates:
    - id: supersedes
      source_types: [Decision]
      target_types: [Decision]
---

# Skogai Knowledge

Structured knowledge for the skogai repo: routing, decisions, and project
context. This replaces the earlier ad-hoc `.skogai/proposals/` and
`knowledge/DECISIONS.md` drafts — see
[decisions/0001-adopt-okf.md](decisions/0001-adopt-okf.md).

## Start Here

* [Agent rules](AGENTS.md) - rules and enabled maintenance behaviors for agents.
* [Spec](SPEC.md) - local pinned copy of the Open Knowledge Format spec.
* [Log](log.md) - chronological update history.

## Sections

* [Decisions](decisions/index.md) - recorded decisions for this repo.
* [Principles](principles/index.md) - global knowledge, staged here until `/skogai/knowledge/` exists.
* [Repos](repos/index.md) - role, state, and workorder caveats for each skogai2 repo.
