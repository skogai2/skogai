# q18 — prune: run these yourself (auto mode refuses volume/image deletion)

status: declined
act: data
kind: choice
thread: podman
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T10:56:27.465344+00:00

## Context

You chose `all` on q13. paperclip-pgdata has never been dumped.

## Options

- volumes — podman volume rm paperclip-pgdata docker_termix-data basic-memory-config
- images — podman image prune -af
- check — podman system df
