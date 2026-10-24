# q13 — podman: prune leftover volumes and images?

status: answered
act: ask
kind: choice
thread: podman
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T10:46:11.356955+00:00

## Context

Volumes in use (termix-data, mcphub_pgdata, basic-memory-pgdata) are never
touched. paperclip-pgdata was never dumped: ~/backups/pg did not exist until
today.

If nobody answers, I prune nothing.

## Options

- all — rm paperclip-pgdata, docker_termix-data, basic-memory-config + image prune -a
+ ~11.7 GB back
- paperclip db gone for good (no dump of it exists)
- images — only podman image prune -a, keep every volume
+ ~11.7 GB back, zero data loss  (★◐)

## Recommendation

images — med
frees the space without losing anything

## Answer

all
answered at: 2026-10-24T10:55:20.672977+00:00
