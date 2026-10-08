# Retro: first dispatch batch (2026-10-07/08)

Seven work orders (`skogai-md-*`), one repo each, all the same task: add a
`SKOGAI.md`. Four merged, two still open (`skogai-md-argc`,
`skogai-md-dash`), one empty/early repo handled specially
(`skogai-md-dot`). This is what actually went wrong or needed a human (me,
the orchestrator) in the loop, and what it cost.

## 1. `dispatch.sh` can't get a worker past the first-run trust dialog

**What happened:** every worktree `herdr worktree create` makes is a path
Claude Code has never seen before, so `herdr agent start` almost always
lands on Claude's "do you trust this folder?" dialog instead of a ready
prompt. `agent start` then returns `agent_not_ready` and the script exits
1 without ever sending the order. 5 of 6 workers in the batch hit this
(1 didn't, for reasons unclear — inconsistent).

**Impact:** `dispatch.sh` is not actually "dispatch and walk away" right
now — every call needs a human or an orchestrator-side follow-up of
`agent read` (see what's on screen), `agent send-keys down`, `agent
send-keys enter`, `agent get` (confirm idle), then manually re-sending the
exact prompt `dispatch.sh` would have sent, then manually patching the
order's frontmatter (`status`/`pane`/`worktree`) since the script never
reached that step either. That's ~5-6 extra tool calls per order, done by
me, not automation. It didn't block the batch — I have the tools to clear
it — but it means today there is no unattended path from "write an order"
to "worker is running."

**Likely fix, not yet done:** `~/.claude.json` has a `projects` map keyed
by absolute path with `hasTrustDialogAccepted`. `dispatch.sh` could write
that key for the new worktree path right after `herdr worktree create`,
before `herdr agent start`, and the dialog would never appear. Unverified
risk: that file's schema is Claude Code's internal state, not a public
config surface, so it could change under us across versions.

## 2. Some workers hit a second, repo-specific blocking dialog

**What happened:** one worker (`skogai-md-okfclaude`) got past the trust
dialog and then hit a second one — "New MCP server found in this
project" (the repo's own `.claude` config declares an MCP server) — which
also needed a manual `send-keys enter` to clear.

**Impact:** the trust dialog isn't the only thing that can stop a worker
cold on first launch. A fix aimed only at trust dialogs won't catch this
class of prompt. Any real fix needs to handle "worker is blocked on *some*
startup dialog," not one specific dialog.

## 3. No way to know a worker finished without actively watching it

**What happened:** to find out when the 6 parallel workers were done, I
ran `herdr agent wait <name>` for each in the background and blocked on
all of them at once in the same turn. That only works because I was still
in the conversation, in one turn, willing to block on it.

**Impact:** there's no push notification into an orchestrator session
when a worker's state changes — `herdr notification` is a one-way desktop
toast, not something a session can subscribe to. If this conversation had
ended, or the batch were large enough that blocking on all of it in one
turn stopped being practical, nothing would have told me (or you) that a
worker had gone from `working` to `done` or `blocked`. The current design
only reports results because I happened to stay and poll.

## 4. `repo:` in a work order isn't actually guaranteed to be a submodule

**What happened:** before writing orders, I assumed every directory under
`projects/` was a submodule with its own git remote. Two weren't:
`skogai-routing` has no `.git` of its own at all (it's plain files
tracked directly in the `skogai` monorepo — `git -C` on it resolves to the
monorepo root), and the "plugins" directory I thought existed at
`projects/plugins` doesn't exist at that path at all; `plugins/` only
exists *inside* several of the real submodules.

**Impact:** had I dispatched an order against `skogai-routing` without
checking this, `dispatch.sh`'s `herdr worktree create --cwd
projects/skogai-routing` would have branched the *entire orchestrator
repo* on a feature branch, and a worker could have pushed/opened a PR
against `skogai2/skogai` itself rather than a scoped project repo. No
order currently checks that `repo:` resolves to an independent git
checkout before dispatch does something destructive with it.

## 5. Order lifecycle tracking is entirely manual, by me, after the fact

**What happened:** `dispatch.sh` writes `status: running` / `pane:` /
`worktree:` on a clean run, but every one of the 6 workers that hit
problem #1 skipped that step (the script exited before reaching it), so I
had to hand-write those fields with `awk`/`sed` after manually continuing
the dispatch. Separately, nothing updates `status: pr-open` → `status:
done` when a PR merges — I only found out 4 of the 7 were merged by
calling `gh pr list --state all` myself and editing each order by hand
just now, prompted by you telling me you'd merged them.

**Impact:** the order file's `status` field is not trustworthy as a
record of truth unless I (or someone) manually reconciles it against
GitHub and against what actually happened in each pane. At 7 orders this
was tedious but tractable; it does not scale to a larger batch or to a
batch run across multiple sessions.

## 6. Order *content* is almost all copy-paste

**What happened:** 6 of 7 orders shared the same ~30-line preamble
(explain the two existing SKOGAI.md styles, explain "don't duplicate
AGENTS.md," explain acceptance criteria) with only the repo-specific
paragraph actually differing.

**Impact:** not a failure, but a cost — writing 6 orders by hand took
real turns and tokens for content that was 90% boilerplate. This is the
one problem that's purely about my/your effort, not about reliability.

## Net effect

Nothing here blocked the batch — all 7 orders ran, all 7 opened PRs, four
are merged. But none of it was unattended: #1/#2 needed me to intervene
mid-dispatch, #3 needed me to actively poll rather than being told, #5
needed me to reconcile state by hand afterward, and #4 was a close call I
only avoided by checking before dispatching rather than because anything
would have stopped me. The gap between "create a work order" and "know,
without asking, that it's done and merged" is currently filled entirely
by me, synchronously, in the conversation — which is the part you said
you want automated end to end.
