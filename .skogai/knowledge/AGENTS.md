---
type: Agent Rules
title: Skogai Knowledge Agent Rules
description: Lightweight starter rules for agents working in this Open Knowledge wiki.
tags: [openknowledge, agents]
generated: { by: process:openknowledge-scaffold, at: 2026-10-09T00:00:00Z }
---

# Agent Rules

You are working inside a local Open Knowledge wiki.

## Rules

* Follow the local [Open Knowledge Format spec](SPEC.md).
* Keep Markdown concept documents OKF-valid with YAML frontmatter and a non-empty type field.
* Treat index.md files as progressive-disclosure indexes.
* Treat log.md files as chronological update logs.
* Keep the folder structure small and shaped around the user's domain.
* Create folders only when they match the interview and expected maintenance loop.
* Keep raw imported material separate from synthesized wiki content when both exist.
* Add workflow docs only for behaviors the user actually wants.
* Do not store agent skills inside the wiki by default; prefer repo-scoped or user-scoped agent configuration where the agent actually reads it.
* Do not treat wiki automation pages as running jobs; real automations belong in the agent runtime or orchestrator that executes them.
* Prefer concise, structured Markdown that future humans and agents can scan.
* Preserve citations or source paths when a page depends on external material.
* After meaningful wiki edits, run okn validate --spec 0.2 and fix issues before finishing.

## Configured Maintenance Rules

These instructions match `[rules].enabled` in `.openknowledge.toml`.

### Project

General project knowledge.

- Before non-trivial work, read the wiki index and follow only links relevant to the task.
- After work creates durable project knowledge, update or add the matching concept pages.
- Keep the wiki structure small and shaped around the project's real workflows.

### Writing

Apply the common editorial rule for any written language.

- Start with the reader's task or required answer.
- Put primary information before supporting context.
- Use one term consistently for each concept.
- Make each actor and action clear when the language permits.
- Keep each sentence and paragraph focused on one idea.
- Remove repeated claims, introductions, and defaults.
- Use progressive disclosure when details interrupt the main task.
- Keep source references for claims that depend on evidence.
- Separate current behavior, planned work, and historical information.
- Give copyable examples for commands, formats, and procedures.
<!-- openknowledge:rules:start -->
## Open Knowledge Maintenance

This project has an Open Knowledge wiki at `.skogai/knowledge`.

This Codex instruction block is managed by `openknowledge prompt rules apply`.

Before relevant work:
- Read `.skogai/knowledge/index.md` and follow only links relevant to the task.
- Treat the wiki as durable project memory, not as a scratchpad.
- If the wiki is missing, stale, or wrong, say so instead of inventing facts.

Enabled rules:
- decisions: Record important decisions.
- agents: Create agent entrypoint docs.
- changelog: Track user-facing changes.

Decisions rules:
- When a meaningful technical or product decision is made, record the context, options, chosen path, and tradeoffs.
- Link decisions to affected concepts, workflows, commands, systems, or source files.
- Do not rewrite decision history to hide old context; append clarifications or superseding decisions.

Agents rules:
- Create focused agent entrypoint docs only when a repeated agent workflow needs a stable handoff.
- Keep entrypoints short and link to deeper wiki concepts instead of duplicating the wiki.
- When useful, wire entrypoints through bundle metadata such as okf_bundle_entry_*.

Changelog rules:
- When user-facing behavior, command flags, output, validation, publishing, packaging, or setup changes, update changelog memory.
- Include what changed, why it matters, source anchors, and docs updated.
- Skip changelog entries for formatting-only edits or internal cleanup with no user-visible effect.

After wiki updates:
- Keep non-reserved Markdown files OKF-valid with YAML frontmatter and a non-empty `type`.
- Update `index.md` links when pages are added, moved, or removed.
- Update `log.md` when durable wiki knowledge changes.
- Run `openknowledge validate ".skogai/knowledge"` before finishing.
<!-- openknowledge:rules:end -->
