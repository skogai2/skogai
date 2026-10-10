# From the ground up — the order of definitions

Draft. The order in which skogai's concepts get defined, so that each step
uses only what the steps before it defined. This has to be agreed before
the definitions themselves.

Proposed by the orchestrator on 2026-10-11, after interview workorder 0020
and `wip/knowledge-definitions.md`. Not yet agreed.

## The rule for every step

A definition names a concept, never a mechanism. "On change" is a concept;
wt, a hook event or a file watcher is not. See
`.skogai/memory/concepts-not-mechanisms.md`.

## Order

0. **Definition vs implementation.** A definition names a concept and lives
   in dash-skogai (`/skogai`). An implementation is how one dot-skogai
   (`.skogai`) realises it. This is the rule step 1 onwards follows. It is
   the dash/dot split, made operational.
1. **type.** What a type is, and what every type definition must state.
   Everything after this step is a type.
2. **router.** How anything is found. It is the one type already in use.
3. **knowledge and memory**, and their types: principle, pattern, decision,
   list, event. Mostly writing down decision 0007 and skogix's older
   schemas.
4. **trigger.** The concepts *on change*, *session start*, *session end*,
   *before merge*. Concepts only, no mechanisms.
5. **tool**, as a concept: what it offers, which triggers it reacts to, and
   which files it touches, split into owned and only pointed at. This is
   the three-part shape of `wip/knowledge-definitions.md` without the
   mechanisms. See also `.skogai/memory/offer-dont-install.md`.
6. **workorder** (or action; the name is skogix's call).
7. **layout.** Not decided separately: each `.skogai/` directory is where
   one of the types above lives.

## Open

- Is the order right? In particular, whether router (2) comes before
  knowledge and memory (3), and whether trigger (4) belongs before tool (5)
  or inside it.
- Where each finished definition lands: dash-skogai `knowledge/`, replacing
  or reworking the 0020 pages (glossary, layout, types).
- How to work through it: one long-lived definer pane in dash-skogai that
  pushes per concept, or steps 0–1 directly in the orchestrator session.
