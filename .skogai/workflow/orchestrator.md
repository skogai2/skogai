# orchestrator workflow

How skogix and the observer (this session) build the orchestrator together.
The observer talks to the orchestrator, judges its output, and keeps an outside view of what works and what doesn't.

- prompt template: `.skogai/templates/orchestrator.md`
- observations: `projects/orchestration/OBSERVATIONS.md` (proposed, not created yet)

## the loop

Repeat these five steps. One pass = one request run through the orchestrator.

1. **goal**: pick one concrete request and write down what "done" looks like before running it (expected setup choice, expected output, expected checks). Keep it small enough to judge in one sitting.
2. **prompt**: fill `.skogai/templates/orchestrator.md` for that request. Change the template only where the last pass showed a gap, and note why.
3. **run**: send the request to the orchestrator. Don't step in while it runs; record where it stalls, asks, or goes wrong.
4. **observe**: compare the result with step 1. Write a dated entry into the observations file as good / bad / open. Rate the orchestrator on what it *did*, not on what it said it did (rerun its checks).
5. **decide**: skogix picks what changes: template, setup, tooling (`bin/agent`, delegate), or the goal itself. Items that aren't fixed now go to `.skogai/TODO.md`. Then start the next pass.

## now (end of this turn)

- [x] write the prompt template from what is known (`.skogai/templates/orchestrator.md`)
- [x] write this workflow
- [ ] skogix reviews both and corrects wrong inferences

## next turn

- [ ] read `projects/orchestration/` and `projects/claude-code/` (README, FEATURES, setups, bin/agent) and diff them against the template. Every mismatch is the first observation entry.
- [ ] read `docs/skogix/introduction.md` and `dash-skogai/SKOGAI.md`, which are still unread
- [ ] agree on the end product: one sentence, e.g. "one sentence in, a reviewed branch waiting for my ok out"
- [ ] create the observations file and settle its format
- [ ] pick the first request for pass 1. Suggestion: a one-shot task (review or commit message), since workers can't see the repo yet and panes add herdr/worktree risk

## open decisions carried forward

- merge policy: orchestrator merges and reports, or prepares and waits (template defaults to wait)
- journal hook in worker worktrees
- who files TODO items: orchestrator, observer, or only skogix
