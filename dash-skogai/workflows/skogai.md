# skogai

how an agent runs [skogai](../type/tool/skogai.md) until `bin/skogai` has the command. `bin/skogai` has only `config` so far. each section is one command, written as a prompt: hand an agent this file and the command name.

paths are relative to the dash root, the folder holding `type/`. `<dot>` is the dot to check. in this repo it is `src`, later `./.skogai`.

## check

pure. reports type errors, writes nothing. safe to run unattended.

do not edit, create or delete any file. if something looks fixable, report it; do not fix it.

run each command exactly as written, one per shell call, from the dash root: no `cd`, `&&`, `;` or pipes. an unattended run allows only these commands, so a chained one is denied.

1. **ref**: run `git rev-parse HEAD` and `git status --porcelain type/`. report the commit, and `dirty` if `type/` has uncommitted changes.
2. **okn**: run `okn validate <dot>`. every okn error is a check error.
3. **cases**: read every `type/<name>.md`. a file whose frontmatter has `type: type` is a case: its `title` is the tag, with its `fields` and `owns`. a file without that frontmatter is a stub: report it as a warning, not a case.
4. **files**: list every file in `<dot>` with `git ls-files --cached --others --exclude-standard <dot>`.
5. **owners**: for each file, find the cases whose `owns` patterns match its path relative to `<dot>`. `<name>` matches one path segment, and a pattern ending in `/` matches everything under it.
   - no owner: `untyped`.
   - a folder pattern and a file pattern both match: the file pattern is the owner.
   - two or more owners left: `conflict`, naming the owners.
6. **tags**: for each `.md` file, read its frontmatter.
   - no `type`: `untagged`.
   - a `type` that is not a case: `unknown tag`.
   - a field from the case's `fields` missing: `missing field`.
7. **derived**: skip. how a type declares a derived file is still open (see [TODO](../TODO.md)). say it was skipped.

### output

one line per finding, then a summary:

```text
error   <path>: untyped
error   <path>: unknown tag "index"
warning type/task.md: stub, no frontmatter
skipped derived files: not specified
dash    <commit> [dirty]
result  errors=<n> warnings=<n>
```

`result errors=0` is clean. do not add advice after the summary.

## plan

not written yet. depends on where a dot records its dash ref and how layers merge (see [TODO](../TODO.md)).

## apply

not written yet. the only writer: needs human approval, never automated.
