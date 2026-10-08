# Decisions

Status values:
- **Decided** — built and tested
- **Chosen** — picked, but cheap to change
- **Open** — needs a decision
- **TODO** — known work, not yet done

### D1. A decision is an entry in a file like this one, following the schema below. Status: Chosen

This is the global, monorepo-level decision record. D1 is reflexive: the
first decision is the definition of what a decision is, so every later
entry (here or in a per-project decisions file) can point back to D1
instead of restating the rules.

*Why:* asked an agent sitting in `projects/skogai-cli` (via herdr) to
write down the rules, format, and schema it could find for a
`DECISION.md`-style file. It read `docs/DECISIONS.md` in that repo and
reverse-engineered the schema below from how that file is actually
written — the schema was never stated explicitly anywhere before this.
This entry promotes that reverse-engineered schema to the global level
and makes it the first decision on record.

*Schema (as reported by the skogai-cli agent):*

- **Grouping** — entries are grouped under thematic `##` headers (topical,
  not numeric ranges).
- **Entry ID scheme** — three independent, sequential prefixes, numbered
  continuously across the whole document (not reset per section):
  - `Dn` — a decision proper
  - `On` — an open question
  - `Tn` — known outstanding work/TODO
- **Entry heading format** — `### <ID>. <one-line statement of the
  decision>. Status: <Decided|Chosen|Open|TODO>`
- **Entry body** — a short paragraph stating what was decided/is open,
  followed by zero or more italic `*Label:*` lines, drawn from a small
  consistent vocabulary:
  - `*Why:*` — the rationale (Decided/Chosen); `*Why it is open:*` is the
    Open-entry variant
  - `*Code:*` — file(s)/function(s) that implement it, in backticks;
    sometimes trails with `Tests: ...` on the same line
  - `*Decide:*` — for Open entries, what specifically needs to be settled
    (used instead of Why/Code)
  - `*Caveat:*` / `*Gotcha:*` — a known wrinkle or failure mode
  - `*Open:*` — a residual sub-issue left even after the entry is
    otherwise decided
  - occasional one-off labels tied to that entry's specifics

*Rules implied by usage:*

1. One entry per decision — don't fold multiple decisions into one ID.
2. `*Code:*` is omitted when nothing is built yet.
3. Chosen entries may use a plain bullet list instead of prose +
   Why/Code — looser because they're cheap to revisit.
4. Open entries skip Why/Code in favor of `*Decide:*` — code can't
   justify a decision that hasn't been made.
5. IDs are never reused or renumbered — once assigned, permanent, even
   across prefix families.
6. Status changes (e.g. Open → Decided) update the entry in place rather
   than creating a new ID.

### O1. Does this global file replace, or sit alongside, `projects/skogai-cli/docs/DECISIONS.md`? Status: Open

*Decide:* whether every submodule keeps its own decisions file following
this same schema (this file then holding only decisions that are
genuinely cross-project/global), or whether this becomes the one place
decisions get recorded and per-project files fold into it.
