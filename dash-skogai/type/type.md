---
type: type
title: type
description: a kind of thing, and the files each of its instances owns, writes and watches.
fields: [type, title, description, fields, owns, writes, watches]
owns: [type/<name>.md, type/<name>.schema.json]
---

# type

a type defines a kind of thing. its definition is `type/<name>.md`, its instances live in `type/<name>/`, and `type/<name>.schema.json`, when there is one, is the schema for those instances. so [type.schema.json](type.schema.json) is the schema for every type definition.

## base

every instance of every type has the okf base. okf requires only `type`; the rest is optional:

- **identity**: `type`, `title`, `description`.
- **provenance**: `sources[]`, `usage_window`.
- **trust**: `generated: {by, at}`, `verified[]`.
- **lifecycle**: `status`, `stale_after`.

## definition

every type states:

- **type**: `type`.
- **title**: its name. instances carry it as their `type` in frontmatter.
- **fields**: the frontmatter every instance must have, beyond `type`.
- **owns**: the paths each instance creates and manages fully. every path has exactly one owner.
- **writes**: the paths each instance modifies without owning them.
- **watches**: the paths each instance reads and wants to know about when they change.

`<name>` in a path is the instance's name. a path ending in `/` is a folder.

## check

- a file with no owner is untyped: an error.
- a file with two owners is a conflict: an error.
- ownership is one step. `type` owns `type/tool.md`; `tool` owns `type/tool/gita.md`. `type` never owns what is under `type/tool/`.
- `writes` and `watches` can overlap freely.

`type` is itself a type: every `type/<name>.md` is an instance of it, including this file.
