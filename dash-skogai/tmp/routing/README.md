# routing

the `skogai-routing` skill (v1 router convention), moved here from `~/skogix/.projects/routing` (added in skogix `31050be`). it existed nowhere else. the older seed is `~/.local/src/skogai-routing`.

folded into dash:

- the router document shape and the `@` vs plain path rules: [type/router](../../type/router.md).
- open questions: `TODO.md`, the `router` items.

kept here, undecided:

- `SKILL.md`, `references/`, `examples/`: the skill as it was.
- `schemas/`: json schemas for a normalized document (`path`, `sections`, `headings`, `links`) and the types `router`, `lesson`, `workflow`, `template`, `reference`.
- `scripts/`: `validate_router.py`, `list_routers.py`, `list_xml_tags.py`, frontmatter parsers.

known broken: `validate_router.py` fails with `Unresolvable: document.schema.json`, because the schemas `$ref` each other by relative id. `router.schema.json` also requires `objective` and `routing` sections, which contradicts the `<routes>` shape in `references/router-file-convention.md`.
