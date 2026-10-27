---
id: herdr-workspaces-doc
status: done
project: /home/skogix/skogai
base: master
branch: task/herdr-workspaces-doc
worktree: /home/skogix/.herdr/worktrees/skogai/task-herdr-workspaces-doc
workspace: w54
agent: hwdoc
kind: claude
---

# document and tidy herdr-workspaces in the orchestrate skill

## spec

`herdr-workspaces` bootstraps the long-lived Herdr project workspaces. It is
**untracked** in the main checkout, so it is not in your worktree yet. Copy it
in first:

    cp /home/skogix/skogai/.skogai/skills/orchestrate/bin/herdr-workspaces .skogai/skills/orchestrate/bin/herdr-workspaces

Do not edit or delete the copy in the main checkout.

Then:

1. Tidy the script without growing it much. Keep it bash, kebab-case and minimal comments.
   - Keep the workspace table as plain data at the top: `label|cwd` entries.
   - Fail early with a clear message if `HERDR_ENV != 1`, or if `herdr` or `jq` is missing.
   - Skip entries whose cwd does not exist, with a message on stderr, instead of failing.
   - Add `--dry-run`. It prints what would be created and creates nothing.
   - Keep it idempotent. Existing labels are skipped, as they are now.
   - Make sure it is executable (`chmod +x`).
2. Document it in `.skogai/skills/orchestrate/SKILL.md`.
   - The Preconditions section says these workspaces are "bootstrapped by
     `~/.local/bin/herdr-workspaces`", but that path does not exist. Point it
     at the skill's own `bin/herdr-workspaces` instead.
   - Add a short section covering what it does, where the workspace list lives,
     how to add a project, and `--dry-run`.
   - Match the skill's existing terse style.

Out of scope: installing it anywhere outside the repo (no `~/.local/bin`
symlink), other skills, and the task template.

## acceptance
- `bash -n` passes on the script, and `shellcheck` passes too if it is installed.
- `herdr-workspaces --dry-run` runs inside Herdr and creates nothing. Check with `herdr workspace list` before and after.
- Do NOT run the script without `--dry-run`.
- SKILL.md no longer mentions `~/.local/bin/herdr-workspaces`.
- The work is committed on `task/herdr-workspaces-doc`.

## result

Commit `f18bc35` on `task/herdr-workspaces-doc`.

- copied `bin/herdr-workspaces` into the worktree; main checkout copy untouched.
- script: `--dry-run`, usage error on unknown args, early exit if `HERDR_ENV != 1` or `herdr`/`jq` missing, skips missing cwds with a stderr message, still skips existing labels, `jq --arg` instead of string-splicing the label. Executable.
- SKILL.md: Preconditions now point at the skill's `bin/herdr-workspaces`; new `## Project workspaces` section (what it does, where the list lives, adding a project, `--dry-run`).

Checks:
- `bash -n` and `shellcheck` (v0.11.0): pass.
- `herdr-workspaces --dry-run` inside herdr: exit 0, no output (all 4 labels already exist). `herdr workspace list` labels identical before/after.
- scratchpad copy with extra `test-new|/tmp` and `test-missing|/nope` entries, `--dry-run`: printed `would create test-new  /tmp` and the stderr skip for `/nope`; workspace list unchanged.
- `HERDR_ENV=0` and `--bogus` both exit 1 with a clear message.
- script never run without `--dry-run`.
- `grep local/bin SKILL.md`: no matches.
