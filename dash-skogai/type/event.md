---
type: type
title: event
description: something that happened, recorded as one row appended to the event log.
fields: [type, title]
owns: [type/event/<name>.md, type/event/<name>.schema.json, scripts/event/<name>.sh]
writes: [.skogai/logs/event.jsonl]
---

# event

an event is something that happened, such as a turn ending or a tool about to run. each time it happens, one row is appended to the event log. rows are never edited; the log as a whole is temporary and can be deleted.

an event `<name>` owns:

- `type/event/<name>.md`: the instance. it says what happened and when it fires.
- `type/event/<name>.schema.json`: its rows. it narrows the row in [event.schema.json](event.schema.json) to this event's `input`.
- `scripts/event/<name>.sh`: what runs when it happens.

- **enabled**: optional. an event runs only when this is `true`. missing, or no instance at all, is off.

## the row

one json object per line in `.skogai/logs/event.jsonl`:

- **ts**: when it happened, utc, to the millisecond.
- **event**: the instance's `title`.
- **action**: optional, what the script did, when it did more than record the row.
- **input**: everything the event came with, unchanged.

## the script

`scripts/event/<name>.sh` gets the event's `input` and appends exactly one row. it may answer: go on, stop with a reason, or a structured answer the event's source understands. when it can't run, it says so and lets the event go on, so a broken script never stops work.

## defaults

no event is on. the log path is the base config key `event.log-path`.
