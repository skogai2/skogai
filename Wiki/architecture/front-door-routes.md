---
type: Reference
title: Front-Door Routes
description: The routes in SKOGAI.md, what each route owns, and where its source is.
tags: [skogai, routes, reference]
---

# Front-Door Routes

These routes are listed in `SKOGAI.md` at the repo root. Each route points to a
home outside this repo. This page only summarizes the route. For the content,
follow the route. Source: `SKOGAI.md`.

| Route | Home | Owns |
| --- | --- | --- |
| dot-skogai | `~/.skogai/skills/skogai-routing/references/dot-skogai.md` | The `.skogai` bootstrap folder convention (`skogai2/dot-skogai`). |
| dash-skogai | `~/.skogai/skills/skogai-routing/references/dash-skogai.md` | `/skogai`, the shared multi-agent workspace. Not provisioned yet. |
| skogix | `~/claude/.skogai/messages/skogix.md` | The skogfences manifesto. |
| claude | `~/claude/CLAUDE.md` | Claude Code's agent home. |
| dot | `~/dot/AGENTS.md` | The dot home (`skogai2/dot`). |
| config | `~/.config/skogai/SKOGAI.md` | `$XDG_SKOGAI_CONFIG_DIR`: env vars, aliases, keybindings (`skogai2/config`). |
| skogai | this repo | The front-door index itself. |

## Notes

* The `~/` paths are outside this repo. Verify that a path exists before you
  rely on it. The wiki does not copy their content.
* `dash-skogai` is marked as not provisioned. Do not treat it as a live home.
