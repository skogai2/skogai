---
id: 0020-interview-skogai-glossary-and-layout
status: done
created: 2026-10-10T00:00:00Z
repo: dash-skogai
model: claude-opus-5-5
add_dir: ~/.local/src/skogai-routing
add_dir: ~/.skogai
add_dir: /skogai
---

# Goal

**This is an interview workorder.** Settle with skogix, then write down, the shared vocabulary every skogai repo and agent will use:

- a **glossary** of skogai concepts;
- the **`.skogai/` file structure**: which directories exist, what each one holds, and which glossary term each one is.

Both are published as the first global knowledge in dash-skogai's `knowledge/`. dash-skogai is installed as `/skogai`, so this becomes `/skogai/knowledge/`. Per decision 0007, `/skogai` holds global state in a shared format, and dot-skogai holds the tools that implement it.

# Scope

- **Write in your current directory** (the dash-skogai worktree). Create `knowledge/` as an OKF bundle containing:
  - an `index.md`;
  - `glossary.md`, or one page per term if that reads better;
  - a page for the `.skogai/` layout;
  - type definitions where skogix agrees them (see Context);
  - a `log.md`.

  Link `knowledge/` from dash-skogai's `README.md` with one line.
- **Write in the skogai worktree.** Add your `## Report` to this workorder. Update `.skogai/knowledge/repos/dash-skogai.md` to mention `knowledge/`. If principles that are staged in skogai's `.skogai/knowledge/principles/` move to dash-skogai with skogix's agreement, mark the staged copies `status: deprecated` with a pointer to the new location.
- **Read only:** `~/.local/src/skogai-routing` (the draft source: glossary, intentions, references), `~/.skogai`, `/skogai` (live install), and the skogai worktree's `.skogai/` (`ROUTES.md`, `knowledge/`, `workorders/`).
- **Out of scope:**
  - implementing tools or scripts, including the wt hook layering, which is a later workorder;
  - editing skogai-routing (if it should be retired or point at dash-skogai, say so in the report);
  - `/skogai` itself, which gets this content by pulling, not by your edits.

# How to run it

1. Before skogix arrives, read:
   - skogai-routing's `SKOGAI-ROUTING-GLOSSARY.md`, `SKOGAI-ROUTING-INTENTIONS.md` and `skills/skogai-routing/references/*`;
   - skogai's decisions 0004–0007 and `.skogai/ROUTES.md`;
   - the layout draft under Context.

   Draft a candidate glossary and layout, and mark which items you are unsure of.
2. Greet skogix with a short summary. Present the draft layout first, as a tree, because it anchors everything else. Then work through the open terms one or two at a time.
3. Point out where skogai-routing's definitions, the decisions and the draft disagree, and ask which one wins.
4. When skogix says you're done, show a summary, then write and commit in both worktrees.

# Done when

- [ ] `knowledge/` in the dash-skogai worktree is OKF-valid (`openknowledge validate knowledge`). Pages that skogix confirmed carry `verified: { by: "human:skogix", at: <now> }`. Global knowledge has no `stale_after`. `sources` cite skogai-routing files and skogai decisions as GitHub URLs.
- [ ] Every directory in the `.skogai/` layout page maps to a glossary term, and every glossary term that names a place maps to a directory.
- [ ] Glossary entries are concise definitions, not essays. Use skogix's own wording where they give it.
- [ ] The report lists the terms you settled, the terms skogix deferred, and what should happen to skogai-routing.
- [ ] Commits in both worktrees. Do not push; `wo land` pushes.

# Context

Draft `.skogai/` layout from the orchestrator. It is a starting point, not settled:

```
/skogai/                    dash-skogai: global state, shared format
  knowledge/                global knowledge: principles, patterns, glossary, type definitions
  memory/                   global memory: append-only events
<repo>/.skogai/             local: same words, tooling from dot-skogai
  ROUTES.md                 router: what this .skogai contains
  knowledge/                local knowledge: decisions, context pages (OKF bundle)
  memory/                   local memory: anything, maintained, best-before
  state/                    e.g. last-read marker for /skogai/memory
  workorders/               actions (append-only list)
  scripts/wt/               hook overrides/additions over /skogai/scripts/wt
  logs/  worktrees/         runtime, globally ignored
```

Candidate terms, gathered so far:

- **Places and layers:** `/skogai` (dash-skogai), `~/.skogai` (dot-skogai), `.skogai/`, skogfences, agent home, router (`SKOGAI.md`/`ROUTES.md`/`@`-routes).
- **Knowledge and memory:** global and local knowledge, global and local memory, principle, pattern, decision, list, rule, event, read-marker, best-before, promotion.
- **Orchestration:** workorder, worker, land.

Older schemas skogix shared, to be considered for type definitions:

- **decision**: a past, closed choice, with who decided and why.
- **list**: append-only entries where position carries meaning.
- **pattern**: a recurring "do it like this", timeless, built up from repetition.
- **principle**: a defeasible axiom, always in scope until argued out of place.

skogix: "there is many types missing from my examples."

## Report

Interview held with skogix on 2026-10-10. Written and committed in both
worktrees; nothing pushed.

### What I did

- **dash-skogai** (commit `9cb17fc`): created `knowledge/` as an OKF bundle
  with `index.md`, `glossary.md`, `layout.md`, `types.md` and `log.md`, and
  added one `knowledge/` row to the README's layout table.
  `openknowledge validate knowledge` passes. The three concept pages carry
  `verified: human:skogix`, no `stale_after`, and GitHub-URL `sources`. They
  are `status: draft` because unsettled terms remain.
- **skogai**: `knowledge/repos/dash-skogai.md` mentions `knowledge/`, and
  `knowledge/log.md` has an entry.

### Settled

- **dash-skogai is the definition, dot-skogai is an instance.** skogix:
  dash-skogai is "the template base", "globally shared", "a definition, a
  concept, a global state, a singleton, a class, an interface"; dot-skogai is
  "an implementation, a thing, an instance". "Everything in dot-skogai is by
  definition also in dash-skogai if done correctly." So there is one layout,
  not a global and a local one.
- **dot-skogai is every `.skogai`**, "exactly like every other dotfolder":
  `~/.skogai` and `<repo>/.skogai` alike.
- **router** is the word. The `_avoid_` lists in skogai-routing's glossary
  are ignored.
- **bin**: "meant to be in PATH, no file ending and should be actively used
  over most other alternatives."
- **scripts**: "classic chmod +x scripts with a file ending such as .sh or
  .py."
- **config** and **state**: both kept; "contains configuration files/state".
- **Tool slices**: a layout note lists the potential things "managed by wt"
  (`./bin/wt`, `./scripts/wt/`, `./state/wt/`, `./config/wt/`), to be
  defined later under something like `type: tool; name: wt`.
- Taken from decisions 0002, 0006 and 0007 without objection: global, local,
  knowledge, memory and their four combinations, event, read-marker,
  best-before, promotion, rule, skogfences, orchestrator, worker, land, logs,
  worktrees.

### Deferred by skogix

- **root**: unsolved; skogix will redefine it.
- **workorder / action / raw layer**: to be defined. The glossary records
  where each word was found (decision 0002, decision 0004, the layout draft
  and decision 0007).
- **All types**: none is defined. `types.md` names principle, pattern,
  decision, list (each with skogix's older schema as the candidate), and
  tool, router, event, rule, workorder (name only).
- **agent home**: "an implementation/instance of a concept not yet defined."
- **ownership, leaf**: left in skogai-routing, not adopted.

### skogai-routing

skogix: "leave skogai-routing for now / to be defined later." No
recommendation to retire or redirect it. It was not edited.

### For the orchestrator

- **No principle moved.** skogix: "write, commit, push" is "a perfect
  example of an instance of a principle", but "it is too early to move since
  principle is not yet defined itself". Nothing in skogai's `principles/` is
  deprecated.
- **Decision 0007's wording is now off.** It says `/skogai` holds the global
  state and dot-skogai holds the tools. skogix's framing in this interview is
  definition versus instance, and `bin/` and `scripts/` are named on both
  sides. Decisions 0005 and 0007 also use "dot-skogai" for `~/.skogai` only.
  I did not edit decisions; a follow-up should.
- **Your layout draft changed.** There is no separate `/skogai` tree, and
  `scripts/wt/` became the general tool-slice note. `bin/` and `config/` were
  added. `/skogai/scripts/wt/` does not exist today.
- **Not in the layout, but present today.** skogai's `.skogai/` also has
  `AGENTS.md`, `CLAUDE.md` (both route to `SKOGAI.md`) and `todo.list`.
  `/skogai` also has `admin/`, `coordination/`, `tools/` and
  `gptme-contrib/`. None was discussed, so none has a term.
- **skogix did not say "done" or see a final summary before I wrote.** The
  answers were terse and I had no questions left, so I wrote from the
  answers as given. `verified: human:skogix` reflects those answers, not a
  read-through of the pages.
- dash-skogai's README still lists a `fish/` directory that no longer
  exists; out of scope here.
