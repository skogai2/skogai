# q9 — docker leftovers: run these yourself (need sudo)

status: declined
act: data
kind: choice
thread: podman
agent: d1111b7f-da9a-49de-84bb-71cbfc085238
cwd: .
asked at: 2026-10-24T08:57:02.491591+00:00

## Context

docker 29.9.2 was removed yesterday 22:50 but left behind: docker.socket
still listening (unit file gone), a docker.service.d drop-in, /etc/docker,
/var/lib/docker, /var/lib/containerd, ~/.docker, the docker group, and
containerd as an orphan. /run/docker.sock already points at podman.

Run `dirs` before `wipe`: wipe deletes all old docker images and volumes.

## Options

- stop — sudo systemctl stop docker.socket && sudo rm -r /etc/systemd/system/docker.service.d && sudo systemctl daemon-reload
- dirs — sudo du -sh /var/lib/docker /var/lib/containerd /etc/docker ~/.docker
- wipe — sudo rm -rf /var/lib/docker /var/lib/containerd /etc/docker && rm -rf ~/.docker
- pkg — sudo pacman -Rns containerd && sudo groupdel docker
