---
id: 0020-interview-skogai-glossary-and-layout
status: open
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
