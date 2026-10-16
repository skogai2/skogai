# Diff as context

Concept notes for future work. This is a concept with the goal of being implemented in the long term.

## The idea

`git diff --cached` plus the user's message is the full context of a turn.

1. **Claude's turn** ends with an entry appended to `.skogai/journal.md` (the user's prompt, Claude's reply, the actions taken), and then everything is staged.
2. **The user** reviews with `git diff --cached` and commits, usually as `WIP`.
3. **The user's turn** is their message plus whatever they changed and staged themselves.

The staged diff then holds both sides: the journal hunk carries Claude's previous turn, and the other hunks carry the user's edits. Each commit is one complete round: what was asked, what was answered and why, and what changed.

## Goal

A message exchange where each side's turn is staged and committed automatically, so the history becomes a git-diff bundle: each commit is one turn's intent (the message, appended to the journal) plus its change.

Each turn, the other party sees:

- the message sent,
- `git diff` and `git diff --cached`: what changed this turn,
- `wt step diff`: everything since branching from the default branch (committed, staged, unstaged and untracked). It fits wt's model: each worktree is a work order against `master`, and new files show up without being added first.

The diffs carry context on their own. A hunk that edits a doc like this one shows the change and the intent behind it together.

