---
name: names-lowercase-one-segment
description: lowercase wherever possible; a name is one segment, `.`/`_` are relations, `-` and case inside a name are dropped.
created: 2026-10-17
stale_after: 2026-11-17
---

skogix, 2026-10-17: "where possible lowercase". `SKOGAI_ENV_VALUE` is
`skogai.env.value`. A single entity's name is one segment: `foo-bar-name`
under `my` is `my.foobarname`, or `MyFoobarname` where case is needed.

**Why:** `.` (key) and `_` (env) mean a relation; anything inside a name is
not structure, so it can't be confused with one.

**How to apply:** files and keys lowercase (`type/event/userpromptsubmit.md`),
keeping the source's spelling only as `title` (`UserPromptSubmit`). Same rule
as dash's `type/config.md` env mapping. Related: [[concepts-not-mechanisms]].

On expiry: promote to a principle once principle is defined, or forget.
