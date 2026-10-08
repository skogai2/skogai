# skogai-git-workflow

A turn-based editing protocol where a `git diff` *is treated and used as a part of the actual message itself*.

## Origin

From a time when every agent message reset the context from scratch and 4k
tokens was the whole budget. There was no room to carry a running
conversation, so the working tree itself became the shared state: instead of
describing a change in prose, you left it as a diff and handed the repo
over. The idea still holds without the token pressure — it's a discipline
for making disagreement and consensus visible in the same artifact you're
already producing.

[@skogix:"i should explain/we should focus on what a message is and how we re-defined literally the representation of state and context that is relevant"]

## The protocol

Two (or more) parties alternate turns on the same working tree. Each turn:

1. **Review the diff you were handed.** `git diff` (unstaged) is the other
   side's current message — their proposal on top of whatever's already
   agreed on.
2. **Stage what you agree with.** `git add -p` (or `git add <path>`)
   whatever makes sense as-is, needs no further discussion, and you'd sign
   off on. Staging is the act of agreement.
3. **Make your own changes.** Edit, add, revert, counter-propose — anything
   you want from the current state. This is your message, and it's left
   unstaged.
4. **Pass the turn.**

Two roles for the two halves of the working tree:

- **`git diff --cached` (staged) = consensus so far.** Nobody disputes it;
  it only grows or changes when someone actively re-stages something during
  their own turn.
- **`git diff` (unstaged) = the current message.** Proposals, edits,
  open questions — written as content, not prose alongside it.

**Commit rule:** staged changes get committed once they've survived two
consecutive clean passes — two turns in a row where the party reviewing
found nothing to add and left nothing unstaged. One quiet turn isn't
enough (it might just be that side skimming); it has to hold twice, i.e.
both sides independently had a turn with nothing left to contest.

[skogix:"obviously insanely simple concepts represented as examples and should be gone over many times to be even closely understood/before even touching something close to implementation"]

## Minimal Viable Product proposal 

```
skogai-turn status             staged vs. unstaged, plus the clean-pass streak
skogai-turn pass [--as NAME]    end your turn
skogai-turn commit [-m MSG]     commit, once two consecutive clean passes happened
skogai-turn reset               clear turn state without touching git
```

State (streak, last author) lives in `.git/skogai-turn/state` — local to the
checkout, never committed, never pushed.

Example session:

```
$ echo "proposal" >> file.txt
$ skogai-turn pass --as alice
turn passed with an open proposal (unstaged diff below) -- streak reset
 file.txt | 1 +

$ git add file.txt            # bob agrees, stages it
$ skogai-turn pass --as bob
clean pass (nothing left unstaged) -- streak now 1/2

$ skogai-turn pass --as alice  # alice reviews, nothing to add
clean pass (nothing left unstaged) -- streak now 2/2
-> two clean passes in a row: ready to commit

$ skogai-turn commit -m "add proposal"
```

Rules the harness enforces that are easy to skip by hand:

- **No consecutive passes by the same name.** `--as alice` twice in a row
  is refused — the whole point is it's the *other* side's turn next.
- **`commit` is blocked below streak 2/2**, and blocked outright if
  anything is still unstaged, even if the streak says otherwise.

What it deliberately doesn't do: pick commit messages, enforce who may
edit what, or replace `git add -p` for actually choosing what to stage.
It only tracks the turn state and gates the commit — the review and
editing stay plain git.
