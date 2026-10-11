# dot-dash-skogai

Working notes on what dash-skogai and dot-skogai are, defined far enough to
start building a CLI and a workflow. Draft, started 2026-10-11.

- [model.md](model.md): the model. dash defines a closed set of types, a
  dot is a tree of typed nodes, state is resolved through layers, and every
  change is a patch.
- [decision.md](decision.md): `decision` written as the first case
  definition, with examples.

## Status

- **Agreed in discussion:** the functional keywords, dot as a discriminated
  union, layers instead of inheritance, git as the immutability model, and
  dash named by ref.
- **Proposed, not confirmed:** the source/derived split, the six parts of a
  case definition, the three CLI commands, and everything in
  [decision.md](decision.md).
- **Not recorded:** none of this is a decision in
  `.skogai/knowledge/decisions/` yet.

## What openknowledge already checks

From reading the docs and Go source in `~/.local/src/okn` (version
0.13.0). Nothing below was run, and the reader could not search the repo,
so treat it as leads to confirm.

**The closed union already exists.** It is called Corpus Schema v1 and is
declared as `corpus_schema:` in the frontmatter of the bundle's root
`index.md` (`Wiki/features/corpus-schema.md`,
`packages/cli/internal/okf/corpus_schema.go`). Once declared, every
document in the bundle must have a declared type and sit on an allowed
path. An undeclared type is an error that cannot be downgraded.

| Part of a case definition | `openknowledge` today |
|---|---|
| Tag | Yes: `document_types[].id`, plus `aliases`. Matching is exact and case-sensitive, so `Decision` and `decision` differ unless one is an alias. |
| Closed set | Yes, bundle-wide, once `corpus_schema` is declared. |
| Place | Yes: `paths`, bundle-relative globs. |
| Fields: required | Yes: `required`, meaning present and non-empty. |
| Fields: value types and enums | No. |
| Body sections | No. |
| Changes (patch rules) | No. |
| Derived files | No. |
| `supersedes` between decisions | Partly: a `link_predicates` entry checks that the target exists and has an allowed type. It does not check cycles, immutability or the matching status change. |

A sketch of the declaration for `decision`, untested, with field names
taken from the source:

```yaml
corpus_schema:
  document_types:
    - id: Decision
      aliases: [decision]
      paths: ["decisions/**"]
      required: [title, description, status, generated]
  link_predicates:
    - id: supersedes
      source_types: [Decision]
      target_types: [Decision]
```

Other findings:

- **No plug-in point.** Neither `validate` nor `check` runs project-defined
  checks. A skogai checker has to run beside them.
- **`ast` is the input for that checker.** `okn ast` prints JSON with typed
  frontmatter (`frontmatter.data`) and the heading tree
  (`markdown.headings`, `markdown.sections`) for every Markdown file.
  `okn list --json` adds the non-Markdown files (`asset`).
- **`status`** is checked by the rule `okf-0.2-metadata`, a warning by
  default. It can be raised to an error in `.openknowledge.toml`.
- **The `decisions` maintenance rule is prompt text only.** Nothing about
  decisions is enforced by validation.

So skogai's own checker is smaller than [model.md](model.md) assumed. It
covers value types, body sections, patch rules and derived files, and it
reads `okn ast`.

Two consequences to decide:

- The bundle is `.skogai/knowledge/`, not `.skogai/`. A closed union over
  the whole dot needs either one bundle at `.skogai/` or a schema per
  bundle.
- A `corpus_schema` lives in each bundle's `index.md`. If dash defines the
  cases, that block is a derived file in every dot.

## Related

- [../ground-up-order.md](../ground-up-order.md): the order in which
  concepts get defined. This folder is step 0 and part of step 1.
- [../TYPES.md](../TYPES.md): every type named so far, and where.
- [../DECISIONS.md](../DECISIONS.md): recorded and unrecorded decisions.
- dash-skogai `knowledge/{glossary,layout,types}.md`: the current global
  pages, which predate this model.
