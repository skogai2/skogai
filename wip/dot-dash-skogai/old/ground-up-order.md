# from the ground up — the order of definitions

draft. 
the order in which skogai concepts should get defined, so that each step uses only what the steps before it defined
this has to be agreed before the definitions themselves


## order

0. **definition vs implementation.** a definition names a concept and lives
   in dash-skogai (`/skogai`). an implementation is how one dot-skogai
   (`.skogai`) realises it. this is the rule step 1 onwards follows. it is
   the dash/dot split, made operational.
1. **type.** what a type is, and what every type definition must state.
   everything after this step is a type.
2. **router.** how anything is found. it is the one type already in use.
3. **knowledge and memory**, and their types: principle, pattern, decision,
   list, event. mostly writing down decision 0007 and skogix's older
   schemas.
4. **trigger.** the concepts *on change*, *session start*, *session end*,
   *before merge*. concepts only, no mechanisms.
5. **tool**, as a concept: what it offers, which triggers it reacts to, and
   which files it touches, split into owned and only pointed at. this is
   the three-part shape of `wip/knowledge-definitions.md` without the
   mechanisms. see also `.skogai/memory/offer-dont-install.md`.
6. **workorder** (or action; the name is skogix's call).
7. **layout.** not decided separately: each `.skogai/` directory is where
   one of the types above lives.


