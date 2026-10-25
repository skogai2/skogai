---
description: Rules for rootless podman quadlets (*.container, *.network, *.pod, *.build)
---

- **Networks are quadlets:** every `Network=` names a `foo.network` file, never a bare `foo`.
  The generator rejects a missing `foo.network` but passes a bare name to podman, which does not
  create it, so the unit crash-loops on `network not found` on any fresh machine.
- **No compose names:** when translating a `docker-compose.yml`, do not carry over generated names
  like `project_network` or `project_pgdata`. Give each a quadlet with a service-prefixed name.
- **Cap restarts:** any unit with `Restart=` sets `StartLimitIntervalSec=300` and
  `StartLimitBurst=10` in `[Unit]`. `Restart=always` + `RestartSec=5` never trips systemd's
  default limit, so a broken unit sits in `activating` forever and never shows `failed`.
- **systemd owns the lifecycle:** use `systemctl --user start|stop|restart`, never `podman stop`
  or `podman rm` on a quadlet container.
- **Stops are not durable:** a unit with `[Install] WantedBy=` comes back at boot. To keep it off,
  remove `[Install]` in the file and commit that.
- **Verify every edit:** run the generator dry run
  (`/usr/lib/systemd/user-generators/podman-user-generator -user -dryrun`) or the repo's health
  check, then `systemctl --user daemon-reload`, then read the unit's journal. A generator error
  silently drops the unit, it does not fail loudly.
- **Monitor boot units:** a repo of quadlets carries a health check on a timer that notifies on
  failure. Reference: `~/.config/containers/systemd/bin/quadlet-health` and its `units/`.
