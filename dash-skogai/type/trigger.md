---
type: type
title: trigger
description: a script that runs when a file changes or an event happens.
fields: [type, title, when]
owns: [type/trigger/<name>.md, scripts/trigger/<name>.sh]
watches: [<when>]
---

# trigger

a trigger `<name>` owns:

- `type/trigger/<name>.md`: the instance.
- `scripts/trigger/<name>.sh`: what runs.

- **when**: the paths or events that run the script.

the base `watches` field is the simplest trigger: it marks interest in a path and runs nothing. a trigger adds the script.
