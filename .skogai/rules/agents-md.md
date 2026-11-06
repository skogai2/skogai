---
description: Agent instructions live in AGENTS.md; CLAUDE.md only links to it
priority: 0
---
- Write agent instructions in `AGENTS.md`, never in `CLAUDE.md`.
- Every `CLAUDE.md` contains only `- @AGENTS.md`, next to the `AGENTS.md` it points at.
- New directory needing instructions: create `AGENTS.md` plus the one-line `CLAUDE.md`.
- Found a `CLAUDE.md` with content: move the content to `AGENTS.md` and reduce `CLAUDE.md` to the link.
- Decided by skogix 2026-11-06.
