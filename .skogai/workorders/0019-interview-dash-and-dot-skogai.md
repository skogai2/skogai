---
id: 0019-interview-dash-and-dot-skogai
status: done
created: 2026-10-10T00:00:00Z
model: claude-opus-5-5
add_dir: ~/.local/src/dash-skogai
add_dir: /skogai
add_dir: ~/.skogai
add_dir: ~/.local/src/skogai-routing
---

# Goal

**This is an interview workorder.** skogix will come to this pane and explain `dash-skogai` and `dot-skogai`: what they are for, how they relate, and where they are heading. Your job is to draw that context out, check it against the files, and turn it into durable knowledge for the orchestrator. The orchestrator never sees this conversation, only what you write.

# Scope

- Read: `~/.local/src/dash-skogai` (source repo), `/skogai` (its live install), `~/.skogai` (dot-skogai), and this worktree's `.skogai/knowledge/`. These are read-only, except for this worktree.
- Write, in this worktree only:
  - Update `.skogai/knowledge/repos/dash-skogai.md`.
  - Create `.skogai/knowledge/repos/dot-skogai.md` and link it from `repos/index.md`.
  - Add a `log.md` entry.
  - If skogix states a real decision, for example about how dash-, dot- and the per-repo `.skogai/` relate, record it as the next numbered decision in `.skogai/knowledge/decisions/`.
- Out of scope: changing anything in the three directories you read.

# How to run it

1. Before skogix arrives, read the three directories and `repos/dash-skogai.md`. Prepare a short list of what you could not work out from the files. Workorder 0007's report has dash-skogai's open questions.
2. Greet skogix with a 3–5 line summary of what you already understand, then your first question. Ask one or two questions at a time. Make them concrete and anchored in files you have read.
3. When something skogix says contradicts the files, say so and ask which one is right.
4. When skogix says they're done, or the open questions are answered, write the outputs. Show skogix a short summary of what you are about to commit, then commit.

# Done when

- [ ] The knowledge pages are OKF-valid. Each has `generated` (you), `verified: { by: "human:skogix", at: <now> }` for content skogix confirmed, `sources` (this workorder plus file paths), and `stale_after` 30 days out.
- [ ] Pages state what is current, keep plans separate from what exists, and record no conversation transcript.
- [ ] The report lists the questions you asked, answered or not, and anything skogix deferred.
- [ ] `openknowledge validate .skogai/knowledge` passes.

# Context

- `.skogai/knowledge/decisions/0003-repo-roles.md`. dot-skogai is currently untracked in gita, and skogix will sort it out later. This interview is part of sorting it out.
- `.skogai/knowledge/decisions/0004-knowledge-lifecycle.md`
- The `skogai-routing` repo's glossary also defines `/skogai`, `.skogai` and "skogfences". Read `~/.local/src/skogai-routing/SKOGAI-ROUTING-GLOSSARY.md` if the terms come up.

## Report

### What I did

- Read `~/.local/src/dash-skogai`, `/skogai`, `~/.skogai`, the skogai-routing
  glossary, and workorder 0007's report. Then I interviewed skogix.
- Rewrote `.skogai/knowledge/repos/dash-skogai.md`. It has separate
  sections for current state and vision.
- Created `.skogai/knowledge/repos/dot-skogai.md` and linked it from
  `repos/index.md`.
- Recorded `.skogai/knowledge/decisions/0005-dash-and-dot-skogai.md` and
  linked it from `decisions/index.md`.
- Added a `log.md` entry.
- All of these pages are `verified: human:skogix`, and skogix reviewed the
  summary before the commit. `openknowledge validate .skogai/knowledge`
  passes.

### Questions asked

1. Which checkout is the source of truth for dash-skogai, `/skogai` or the
   gita clone? **Answered:** neither. The remote origin is the only source
   of truth, and all local checkouts are disposable. The goal is to rebuild
   the machine from the ground up, from archinstall, on each iteration.
2. What is dot-skogai now? **Answered:** it is the old user-level layer,
   the skogai counterpart of `~/.claude`. `/skogai` plus skogcli replaced it
   as the shared layer. It is empty only because no installer exists yet,
   and it *will* be used.
3. The README's `755` permissions and sole-committer setup contradict
   "agents have full access, and changes go through PRs every agent
   approves". **Answered:** the second describes the goal, not the current
   state.
4. Where do dash-skogai workorders go? **Answered:** dispatch to whichever
   repo a change belongs in, the same as for every repo. That includes
   dot-skogai.
5. Should decision 0005 be recorded? **Answered:** yes, with corrections
   that are now applied: rebuild-per-iteration is a goal, git-state and
   implementation details are left out, and there is no "don't dispatch to
   dot-skogai" rule.
6. Should I add a caveat about the secrets in the old ansible `roles/ssh`?
   **Answered:** no. The files are vault-encrypted and the keys are
   regenerated each time, so I recorded nothing.

### Deferred / open

- How the dot-skogai installer will work is undecided. skogix says only
  the end goal, intent and vision matter at this stage.
- dot-skogai is still untracked in gita, so `repo:` cannot target it until
  it is added (decision 0003).
- Following skogix's "no implementation details" direction, I dropped from
  the pages two items in favor of the vision: the staged `openknowledge`
  change to `mise.toml` that exists only in `/skogai`, and the
  submodule/hardcoded-path caveats from 0007. They are still in 0007's
  report.
