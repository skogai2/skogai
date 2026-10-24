# q6 — podman: how should I fix the half-done tunnel rename?

status: answered
act: ask
kind: choice
thread: podman
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T08:40:11.734749+00:00

## Context

Both end with daemon-reload and starting skogai-tunnel. Still to check in
both cases: tunnel name `skogai-cloudflare` vs `skogai` on Cloudflare.

Missing ~/.local/src build dirs are a separate issue, not part of this.

If nobody answers, I change nothing.

## Files

- /home/skogix/.config/containers/systemd/skogai-cloudflare/skogai-tunnel.container
- /home/skogix/.config/containers/systemd/mcphub/skogai-mcphub.container
- /home/skogix/.config/containers/systemd/termix/termix.container

## Options

- finish — rename files to skogai-cloudflare.*
+ matches commit 7531fae intent
- edit mcphub/termix Network=, restart them  (★◐)
- revert — point container back at skogai-tunnel.network/.env
+ two-line edit, nothing else moves
- names stay inconsistent with the directory

## Recommendation

finish — med
the rename was clearly intended

## Answer

skognet-cloudflare=main cloudflare tunnel to be used as the endpoint/thing that separate userspace from container-only-access, skogix-laptop-service, skogix-workstation-service, *-service is "sudo-ssh-focused-services which should have essentially things only - i.e. systemd sudo level access". this means essentially "skognet overall, cloudflare, termix, tailscale, netbird, pangolin etc etc etc is meant to work in closed of systems such as "podman with the only access to internet and outside the container is to a tunnel to similar enviornments" if that makes sense. please document this if not done already
answered at: 2026-10-24T10:34:48.415415+00:00
