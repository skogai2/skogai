---
description: skogai-runner and module conventions (usage + mise)
paths:
  - "src/**"
  - "bin/**"
  - "modules/**"
  - ".skogai/workorders/**"
---

# skogai-runner conventions

skogai-runner is a front-door command runner and relationship manager. It stays minimal, primitive, and unopinionated.

## Core interface: usage + mise

- **usage**: Scripts declare their CLI in `#USAGE` comments and run under `usage bash`. Usage handles parsing, completion, and agent metadata (`usage mcp`). Do not extend or introduce `argc`.
- **mise**: Mise is the modular execution engine. It natively provides tools, PATH, `config`, `variables`, `environment`, and `settings`. skogai dynamically creates and switches mise setups per execution turn.
- **Hierarchical usage spec**: The top-level CLI is a single hierarchical `usage` spec that statically forwards arguments, importing external module specs and scripts directly as subcommands.

## Boundaries and Ownership

- **Modules own their implementation details**: Contract checking, validation, and internal behavior belong inside modules, not in the runner core.
- **Module-driven logging**: Modules explicitly emit domain and execution events using `src/core/log` (`skogai log emit <type> [--json '<payload>']`). The runner does NOT automatically wrap commands or inject synthetic logging.
- **Templates from workorders**: Workorders declare required module combinations in Markdown frontmatter. As combinations run, the runner caches them as reusable template Markdown files in `.skogai/templates/`.
- **Module layout**:
  - Built-in core modules: `src/core/<module>/` (e.g. `src/core/log/`, `src/core/config/`).
  - External / user modules: dedicated user/repo dot paths (e.g. `~/.skogai/modules/` or `<dot>/modules/`).
