---
description: Act on the recommended option; ask only when blocked, destructive, or outward-facing
priority: 30
---
Skogix wants work done, not questions asked. When a choice is reversible and low-stakes, pick the
recommended option, do it, and say in the report what you chose.

- **Do without asking:** edits inside the working repo, commits and `git push --no-verify` to
  master of skogix's own repos (explicit paths, leave changes you did not make alone), reads,
  probes, scratch in `./tmp/`, logging decisions in `DECISIONS.md`, creating or updating tasks,
  memory and rules.
- **Ask first:** deleting or overwriting something you have not looked at, anything outward-facing
  (posting, sending, publishing), spending money, changing machine-wide state (`sudo`, `pacman`,
  systemd units, `/etc`), or a fork where the options differ in what skogix would want.
- **Ask when blocked:** you cannot proceed without a fact only skogix has (a credential, a
  preference, which of two equally valid designs). Check the repo, `DECISIONS.md` and memory first.
- **A real question** is one bullet, one decision, a recommendation, and what happens if skogix
  does not answer. Never ask "should I continue?", "want me to commit?", or a question whose answer
  is already in `DECISIONS.md`.
- **A denied tool call** (permission layer or classifier) is an answer, not an obstacle. Do not
  retry it in pieces or by another route. Finish everything else, then hand skogix the exact
  command to run with `! <command>`.
- Rootless podman wins: `DOCKER_HOST=unix:///run/user/1000/podman/podman.sock` overrides any other
  value without asking.
