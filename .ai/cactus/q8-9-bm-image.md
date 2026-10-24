# q8 — basic-memory: where should its image come from?

status: answered
act: ask
kind: choice
thread: podman
parent: q6
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T08:57:02.378512+00:00

## Context

basic-memory-postgres is already up and healthy; only the app is down,
because basic-memory.build points at the missing ~/.local/src/basic-memory.

If nobody answers, I change nothing.

## Files

- /home/skogix/.config/containers/systemd/basic-memory/basic-memory.container
- /home/skogix/.config/containers/systemd/basic-memory/basic-memory.build

## Options

- local — Image=localhost/basic-memory:dev (built Oct 8)
+ starts right now, no source needed
- frozen; 4.2 GB image  (★◐)
- rebuild — point basic-memory.build at ~/a/basic-memory
+ keeps the build pipeline
- unknown if ~/a copy is the right branch

## Recommendation

local — med
fastest path to a working backend

## Answer

`uv tool install basic-memory` -> some smaller changes to `basic-memory config list` to make it postgres based is enough for now. no need for building from source etc etc at this point
answered at: 2026-10-24T10:37:05.690597+00:00
