---
name: runner-and-mise-boundaries
description: "Division of responsibilities: mise is the modular environment/config engine; runner is the relationship and context orchestrator."
metadata:
  node_type: memory
  created: 2026-11-07
  originSessionId: b8884808-3330-41a1-84a4-b2e141544e55
---

skogix, 2026-11-07:
"we are the ones that manage the relationship between modules, related context, how things actually act and behave etc.
mise is built to be a solid developer environment with everything needed - we are using it as a modular change-repo-environment-path-context-etc-every-turn-and-create-mise-setups-dynamically-when-needed"

- Mise manages: tools, environment, PATH, variables, config, and settings.
- Runner manages: module registry, context relationships, dynamic assembly of mise setups, and dispatch via hierarchical usage specs.
- Logging and contract validation remain inside module boundaries; the runner stays minimal and does not wrap commands automatically.
