---
type: decision
title: a decision is one typed file in decisions/
description: defines the schema a decision file follows - frontmatter, body sections, numbering
tags: [decision,router,type]
status: stable
generated: { by: "user:skogix"}
permalink: decision/0001-types
---

# proposal

this is a example proposal of how types and formatted decisions could be done and needs to be expanded heavily upon

example of open knowledge decisions and how it could look. 

from the opf plugin for claude code:
```yaml
---
type: decision
title: title
description: description
tags: [decision,router,type]
status: stable
generated: { by: "user:skogix", at: "<timestamp>"}
---
```

now what is needed, generated and everything surrounding this needs to be re-evaluated taking open knowledge format into consideration.  

# context

skogix extras to discuss for later/probably made into separate proposals:

## permalink

```yaml
permalink: knowledge/decision/0001-types
```

- checked SPEC.md: `permalink` doesn't appear anywhere in it. Confirms
  it's not an OKF field — whatever this ends up being, it's something
  layered on top, not something the spec already defines for us.

## types and functionality

example: routes and relative links. for example i would like to @path/to/the/SPEC.md in the wiki, opf definitions etc etc etc right here


# decision

A decision is one file in `.skogai/knowledge/decisions/`, typed `type:
- a decision would better be described with its intentions. otherwise we would probably say something like "a knowledge file following the open knowledge format 0.2 with the type decision" and then define the rest below. maybe add another header such as "definitions or spec" which is the more technical things to take away from the decision?    
decision` in its frontmatter and numbered by filename (`000N-slug.md`).
- should numbering be in the frontmatter instead? or at all?
This entry is reflexive: decision 0001 is the definition of what a
decision is, so every later decision file can point back to it instead
of restating the rules.

Frontmatter:

- `type: decision`
- `title` / `description` — short, free-form summary.
- `tags` — free-form, for lookup.
- `status` — lifecycle of the decision itself (e.g. `stable`, `draft`,
  `open`).
  - is this defined in the 0.2 spec or not?  
  - checked SPEC.md §5.4: `status` is a real spec field, but the only
    valid values are `draft | stable | deprecated` (absent ⇒ `stable`).
    `open` isn't one of them — spec's `status` describes the *file's*
    lifecycle (reviewed? current?), not whether the decision topic is
    settled. Those read like two different axes we're conflating.
- `generated: { by, at }` — who/what produced the file, and when.
  - checked SPEC.md §7: actor convention wants `human:<id>` for a
    person, e.g. `human:skogix` — not `user:skogix` as currently
    written (both files use `user:skogix`). §5.3 keys trust-tier
    classification off that `human:` prefix specifically.

Recommended body sections

- `# proposal` — what's being proposed, and why.
- `# context` — background, open sub-questions, things to discuss
  separately.
- `# decision` — what was actually decided.
- `# consequences` — what the decision implies or rules out.

Recommended rules and guidelines

- One concept per file
- Build upon the Open Knowledge Format 
- Use *EITHER* a shared DECISIONS.md index file with summaries and links to the actual decisions themselves or implement a solution with index.md files via OFK
  - checked SPEC.md §8: `index.md` is the spec-native mechanism for
    this already — no frontmatter at all (except a bundle-root
    `okf_version`), just enumeration for progressive disclosure. A
    hand-maintained `DECISIONS.md` with summaries would be a bespoke
    thing living next to that, not an OKF-native alternative to it.

# consequences

- Decisions live under `.skogai/`, following the dot-skogai bootstrap
  convention, instead of at the repo root.
- A flat, root-level `DECISIONS.md` (with a `### Dn`/`On`/`Tn` heading
  scheme reverse-engineered from `projects/skogai-cli/docs/DECISIONS.md`)
  existed briefly before this directory did. See
  `0002-root-decisions-file.md` for what happened to it and to its first
  entry, which asked this same question.

# routes

- @0002-root-decisions-file.md
- SPEC.md of the open knowledge format

# discussion

## superseding an earlier decision
## one concept per file
