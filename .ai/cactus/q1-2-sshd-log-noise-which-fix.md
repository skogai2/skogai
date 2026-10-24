# q1 — sshd log noise: which fix should I do next?

status: answered
act: ask
kind: choice
thread: sshd-noise
agent: 7219e48e-dd91-4c86-aac6-c760f33e4362
cwd: .
asked at: 2026-10-24T04:44:27.222475+00:00

## Context

Connections close preauth every ~5-20s from tailnet (100.64.0.x) and
LAN (10.10.4.3), so it looks like health checks or monitors. The PQ warning
means 10.10.4.3 runs OpenSSH older than 9.9.

If nobody answers, I change nothing.

## Options

- probe — find what 100.64.0.25/.60 and 10.10.4.3 run against :22
+ fixes the cause, keeps login audit
- needs access to / knowledge of those hosts  (★◐)
- quiet — drop-in sshd_config.d/10-quiet.conf with LogLevel ERROR + reload
+ instant, one file
- loses "Accepted publickey" login records; needs sudo
- view — nothing on the server, use systemctl status sshd -n0
+ zero risk
- journal still fills with probe lines

## Recommendation

probe — med
cause-level fix, no audit loss

## Answer

it was termix trying to ssh to localhost via tailscale which suprisingly enough did not work what so ever - from its point of view. fixed now
answered at: 2026-10-24T10:29:15.142888+00:00
