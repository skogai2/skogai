---
type: Concept
title: Skogai Overview
description: What the skogai front-door repo is, what it holds, and what it does not hold.
tags: [skogai, overview]
---

# Skogai Overview

`skogai` (repo `skogai2/skogai`) is the front-door index for the Skogai
workspace. Its job is to route a reader or agent to the right home for a
topic. It does not hold the detailed guidance itself.

## What the repo contains

* `SKOGAI.md`: the routing file. It lists the homes and says what each one is for.
  Source: `SKOGAI.md`.
* `AGENTS.md`: a router that imports `SKOGAI.md`. Source: `AGENTS.md`.
* `projects/`: two git submodules and two routing design notes.
  See [Submodules](projects/submodules.md).

## What the repo does not contain

* Detailed guidance for other homes. Those live in the repos that `SKOGAI.md` routes to.
* Generated or raw knowledge. This wiki is the only maintained synthesis in the repo.

## Related

* [Routing model](architecture/routing.md): how files own and point to other files.
* [Front-door routes](architecture/front-door-routes.md): the current list of routes.
