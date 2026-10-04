---
type: Agent Rules
title: Skogai Wiki Agent Rules
description: Rules for agents that read and update the Skogai front-door wiki.
tags: [openknowledge, agents, skogai]
---

# Agent Rules

You are working inside the Skogai Wiki, a local Open Knowledge bundle that
documents the `skogai` front-door repo.

## Purpose

* Explain what the repo holds, how its routes work, and how to maintain them.
* Do not copy the content of routed homes into this wiki. Link to them instead.

## When to read the wiki

* Before you change `SKOGAI.md`, `AGENTS.md`, or any file under `projects/`.
* When a task asks how skogai routes, owns, or links files.

Start at [index.md](index.md) and follow only the links that match the task.

## When to update the wiki

* A route is added, moved, renamed, or removed. Follow [Update routes](workflows/update-routes.md).
* A submodule pin changes or a submodule is added or removed.
* The routing model changes, for example a new term or a new ownership rule.
* A setup or maintenance decision is made. Record it in [log.md](log.md).

## When not to update the wiki

* Do not edit the content of routed homes (`~/claude`, `~/dot`, `~/.config/skogai`).
  Those files belong to their own repos.
* Do not edit the submodule contents under `projects/ofk-*`.
* Do not add speculative plans as current behavior. Label planned work as planned.
* Do not change `index.md` for small edits that fit an existing page.

## Source and provenance

* Name the source path for every claim that depends on a file. Example: `Source: SKOGAI.md`.
* Keep current behavior, planned work, and history in separate sections.
* Do not select between conflicting sources. Record the conflict and leave both visible.

## Validation

After any meaningful wiki edit, run:

```bash
okn validate --spec 0.2 Wiki
```

Fix all errors and avoidable warnings before you finish.

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
