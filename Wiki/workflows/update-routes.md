---
type: Workflow
title: Update Routes
description: How to add, move, or remove a route in SKOGAI.md and keep the wiki in step.
tags: [skogai, workflows, routes]
---

# Update Routes

## Trigger

A home is added, renamed, moved, or removed. Or a route description changes.

## Inspect

* `SKOGAI.md`: the current `<routes>` list.
* The target home: confirm that the path or repo exists and that its owner matches the route name.
* [Front-door routes](../architecture/front-door-routes.md): the wiki copy of the list.

## Update

* `SKOGAI.md`: add, change, or remove one route line in the `<routes>` block.
* [Front-door routes](../architecture/front-door-routes.md): match the table to `SKOGAI.md`.
* `log.md`: add one dated entry that names the route that changed.

## Do not update

* The content of the home that the route points to. That home owns its own content.
* `projects/` submodule pins. Those change only through the submodule workflow.
* The routing model, unless the change alters the ownership rules.

## Verify

1. Confirm each route path exists. Use `ls` on the path, or `test -e` for `~/` paths.
2. Run `okn validate --spec 0.2 Wiki` from the repo root.
3. Check that `front-door-routes.md` and `SKOGAI.md` list the same routes.
