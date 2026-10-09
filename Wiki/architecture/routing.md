---
type: Concept
title: Routing Model
description: Ownership, routing files, leaves, and the root, as used by skogai-routing.
tags: [skogai, routing, glossary]
---

# Routing Model

Skogai uses a small set of terms to say which file is responsible for
which context. The full narrative source was `projects/SKOGAI-ROUTING-GLOSSARY.md`,
in the `projects/` directory removed 2026-10-09 (commit `a99d6d2`). That source
no longer exists in this repo; the terms below are this wiki's own record of it.

## Terms

* **Ownership.** A file, concept, or tag that another file belongs to or is
  responsible for. A file can have more than one owner. Avoid the words
  "parent" and "manages".
* **Routing file.** An all-caps Markdown file, such as `SKOGAI.md`, `CLAUDE.md`,
  or `AGENTS.md`. It owns other files and points to them. Its name is the
  marker. A lowercase file that does the same job is not a routing file.
* **Leaf.** A file that has an owner and owns nothing. It ends the chain.
* **Root.** The routing file at a repo's git root. It is the only file with no
  owner inside the graph. Its `permalink` names the repo's external identity.
  For this repo the permalink is `skogai/skogai`.

## Rules

* Ownership is not transitive. If A owns B and B owns C, A does not own C.
  Each step is one hop to a direct owner.
* A reader walks the graph one step at a time. Walking further is a separate lookup.
* Each piece has one job: route, procedure, fact, output shape, or repeatable check.

## Current behavior and planned work

* Current: routing files list links with `@` imports inside a `<routes>` block.
  Source: `SKOGAI.md`, `AGENTS.md`.
* Planned: the routing project was meant to prove the routing step first,
  with other pieces (such as a knowledge bundle under the routes) coming
  later. Source was `projects/SKOGAI-ROUTING-INTENTIONS.md`, removed
  2026-10-09 along with `projects/`; whether this plan still holds is unverified.

## Related

* [Front-door routes](front-door-routes.md)
* [Update routes workflow](../workflows/update-routes.md)
