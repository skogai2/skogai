---
name: read-vendored-docs-first
description: "a repo's docs/ (argc, mise, ...) is there to be read before designing; build on the tool's own features, one small step at a time."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 55ca1937-ab25-4eaf-9bb6-0d42d8cc463a
  modified: 2026-10-28T15:19:57.472Z
---

In skogix-argc-runner-module (2026-10-28) a ~14h session drifted from "a
small argc wrapper" into hand-rolled layering (yq/jq folds, custom
module discovery, add-up lists) while `docs/argc` and `docs/mise` already
had the answers: argc `@env` defaults, `@meta dotenv`, bind-env
(`$$`/`$NAME`, flag > env > default), `--argc-eval`/`--argc-export`;
mise `[vars]`/`-E` profiles/conf.d/`mise vars`. The user had to show
each feature by running it themselves.

**Why:** the user vendors docs so the tool does the work; reinventing it
cost hours and trust. Building ahead of the asked step (specs for
layers, profiles, install) made it worse.

**How to apply:** before writing code or a spec, grep the vendored docs
for the tool feature that does it and test that feature first. Do one
asked step at a time; don't design beyond it. When the user runs a
command at you, find what it demonstrates in the docs before
commenting. Related: [[trust-existing-systems]], [[concepts-not-mechanisms]].
