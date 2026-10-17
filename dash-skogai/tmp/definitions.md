# definitions

everything dash names, and how far each one is defined. one place to see what is left before `check`, `plan` and `apply` can work.

status: **defined** (frontmatter + body + no blocking open item), **partial** (defined, with open items), **draft**, **stub** (file exists, nothing in it), **missing** (used or implied, no file).

## types

```text
type      :: { type, title, description?, fields, owns, writes?, watches? }
instance  :: { type: <title of a type>, title, ...fields }
path      :: string            -- `<var>` placeholders, trailing `/` is a folder
```

| type | status | fields | owns | writes | watches | instances | open |
|---|---|---|---|---|---|---|---|
| [type](../type/type.md) | partial | type, title, description, fields, owns, writes, watches | `type/<name>.md`, `type/<name>.schema.json` | | | 13 types | `fields` as list vs map; `owns` required on every instance; `created`/`edited`; okf base vs `additionalProperties: false`; how a type declares a derived file |
| [config](../type/config.md) | partial | type, title | `config` | | | `config` (base) | strict vs free-form keys; append-merge for lists; `dash.ref` in local?; env namespace collision (`SKOGAI_GLOBAL_CONFIG`) |
| [decision](../type/decision.md) | partial | type, title, status | `type/decision/<nnnn>-<name>.md` | `DECISIONS.md` | | **none** (`0006` is cited, no `type/decision/` exists) | `supersedes` not in `fields`; generator for `DECISIONS.md` |
| [rule](../type/rule.md) | partial | type, title, applies_to | `type/rule/<name>.md` | | `<applies_to>` | none | `from` not in `fields`; define its own watched-file field |
| [trigger](../type/trigger.md) | partial | type, title, when | `type/trigger/<name>.md`, `scripts/trigger/<name>.sh` | | `<when>` | none | split `when` into `event` + paths; overlaps rule/watches |
| [tool](../type/tool.md) | defined | type, title | `type/tool/<name>.md`, `bin/<name>`, `scripts/<name>/`, `workflows/<name>.md` | | | gita, herdr, mise, okn, skogai, wt | confirm `docs/tools/` → `type/tool/`, `workflow/` → `workflows/` |
| [event](../type/event.md) | partial | type, title | `type/event/<name>.md`, `type/event/<name>.schema.json`, `scripts/event/<name>.sh` | `.skogai/logs/event.jsonl` | | 13 hook events | `enabled` not in `fields`; no `scripts/event/` yet; key `event.log-path` not in base `config` |
| [router](../type/router.md) | draft | type, title | `<name>/SKOGAI.md`, `<name>/CLAUDE.md` | | | none typed | keep or move back to tmp (decision 0006); `<name>/` breaks the `type/<type>/<name>` pattern; root-xml-block rule for all types?; permalink resolution |
| [knowledge](../type/knowledge.md) | stub | | | | | | split vs memory on lifetime (`status`/`stale_after`?) |
| [memory](../type/memory.md) | stub | | | | | | see knowledge |
| [task](../type/task.md) | stub | | | | | | rename (`workorder`?) — collides with mise / claude code |
| [spec](../type/spec.md) | stub | | | | | | overlaps type + rule: proposal/design, or drop |
| [repo](../type/repo.md) | stub | | | | | | relation `gh/skogai`; may absorb router permalinks |

## tool instances

| tool | status | owns on disk | open |
|---|---|---|---|
| [skogai](../type/tool/skogai.md) | partial | `bin/skogai` (config only), `workflows/skogai.md` | `check` in workflow / `mise run dash:check`; `resolve`, `plan`, `apply` unwritten |
| [herdr](../type/tool/herdr.md) | gotchas only | | body |
| [wt](../type/tool/wt.md) | gotchas only | | body |
| [gita](../type/tool/gita.md) | stub | | body; the "module" example (`bin/gita`, `scripts/gita/*`) |
| [mise](../type/tool/mise.md) | stub | | body |
| [okn](../type/tool/okn.md) | stub | | body |

## modules

```text
module :: instance -> [path]   -- every file an instance owns or relates to
```

missing. a type's `owns` already is the module for its instances, but there is no way to declare *extra* paths per instance (`bin/gita`, `scripts/gita/*`).

- okn `typed_links` can't target non-document paths; okf `resource` is one path.
- candidate: `owns: [paths]` on the instance, checked by `skogai check` after `okn validate`.

## core values (used, not typed)

| name | signature | where | open |
|---|---|---|---|
| dash | `{ ref, commit, types, functions }` | [skogai](../type/tool/skogai.md) | — |
| dot | `closed-union<instance>` on disk (`.skogai/`) | [skogai](../type/tool/skogai.md) | layout of `.skogai/` is undefined |
| ref | `string -> commit` | design goals | where a dot records its dash ref |
| layer | `base \| global \| local \| file \| env` | [config](../type/config.md) | — |
| resolved | `fold(merge, [base, global, local])` | [skogai](../type/tool/skogai.md) | merge per field (replace vs append) |
| merge | `(value, value) -> value` | [config](../type/config.md) | only replace defined |
| patch | `git diff` | [skogai](../type/tool/skogai.md) | — |
| finding | `{ level, path, kind }`, kind ∈ untyped, conflict, untagged, unknown tag, missing field | [workflows/skogai](../workflows/skogai.md) | `--json` shape |
| derived | `[path] -> path` | `DECISIONS.md`, `CLAUDE.md`, `tmp/graph/types.md` | how a type declares it, and by what function |
| event row | `{ ts, event, action?, input }` | [event.schema.json](../type/event.schema.json) | — |
| relation | one step: `<parent>/<child>` | TODO | every `<var>` in a path defined by the instance or its parent |

## path placeholders

| placeholder | used by | bound by |
|---|---|---|
| `<name>` | every type | instance title |
| `<nnnn>` | decision | undefined (next free number?) |
| `<applies_to>` | rule | field `applies_to` |
| `<when>` | trigger | field `when` (paths *or* events — mixed) |
| `<repo>` | config local layer | undefined (repo type?) |

## files in dash with no owner

`check` would report these today.

| path | proposed owner |
|---|---|
| `SKOGAI.md`, `CLAUDE.md` | router (draft); `CLAUDE.md` should become derived `@SKOGAI.md` |
| `TODO.md` | none — task? |
| `type/index.md`, `src/index.md` | router, or a new `index` type |
| `type/type.schema.json`, `type/event.schema.json` | type (`type/<name>.schema.json`) ✓ |
| `type/event/<name>.schema.json` | event ✓ |
| `tmp/**` | untyped by design |

## tmp/routing leftovers

| thing | maps to | decision |
|---|---|---|
| `lesson.schema.json` (match.keywords, rule/context/pattern) | knowledge / memory | open |
| `workflow.schema.json` (objective/steps/validation) | `workflows/<name>.md` under tool | open |
| `template.schema.json`, `reference.schema.json` | — | open |
| `scripts/validate_router.py` & co | `skogai check` | port or drop |
| `references/at-linking.md`, `dynamic-output-blocks.md` | knowledge, or marketplace | open |

## order

what unblocks the most, first:

1. `type` schema: `fields` as map, `owns` on every instance → fixes every partial type's missing fields (`supersedes`, `from`, `enabled`).
2. derived files → `DECISIONS.md`, `CLAUDE.md`, graph.
3. where the dot records its dash ref + merge per field → `plan` / `apply`.
4. stubs: keep, merge, or drop (knowledge/memory, task, spec, repo).
5. router: promote or move back.
