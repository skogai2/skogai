# q11 — prune: keeping pangolin + skognet-dns despite keep-termix

status: answered
act: steer
kind: choice
thread: podman
parent: q7
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T10:38:27.584548+00:00

## Context

Both are manual (no [Install]) and stopped, so keeping them costs nothing at
boot.

## Options

- keep — remove only agentbot, agentchattr, paperclip
+ your q6 note lists pangolin and skognet as part of the closed network  (doing)
- remove — also git rm pangolin/ and skognet-dns/
+ exactly what keep-termix listed

## Answer

remove
answered at: 2026-10-24T10:42:14.464858+00:00
