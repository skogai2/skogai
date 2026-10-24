# q7 — podman: which non-core services should I remove?

status: answered
act: ask
kind: choice
thread: podman
parent: q6
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T08:57:02.267349+00:00

## Context

"Remove" means: stop the unit, git rm its directory in ~/.config/containers/systemd
(so git can bring it back), daemon-reload. Volumes (paperclip-pgdata,
docker_termix-data) and images stay until a separate prune step.

If nobody answers, I remove nothing.

## Files

- /home/skogix/.config/containers/systemd/termix/termix.container
- /home/skogix/.config/containers/systemd/PLAN.md

## Options

- keep-termix — remove agentbot, agentchattr, paperclip, pangolin, skognet-dns
+ termix is running and on the tunnel
- one more thing to maintain  (★○)
- core-only — also remove termix + guacd
+ only tunnel, mcphub, basic-memory left
- loses the termix web ssh

## Recommendation

keep-termix — low
termix is live and wired to the tunnel

## Answer

keep-termix
answered at: 2026-10-24T10:35:17.629144+00:00
