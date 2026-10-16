---
type: type
title: tool
description: an executable skogai uses, with its wrapper, scripts and workflow.
fields: [type, title]
owns: [type/tool/<name>.md, bin/<name>, scripts/<name>/, workflows/<name>.md]
---

# tool

instances: [herdr](tool/herdr.md), [wt](tool/wt.md), [gita](tool/gita.md), [mise](tool/mise.md), [okn](tool/okn.md).

a tool `<name>` owns:

- `type/tool/<name>.md`: the instance, and its documentation.
- `bin/<name>`: the entrypoint.
- `scripts/<name>/`: everything the entrypoint calls.
- `workflows/<name>.md`: how and when to use it.
