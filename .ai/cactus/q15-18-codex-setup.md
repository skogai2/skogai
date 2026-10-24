# q15 — Waiting for your new thread before touching anything

status: answered
act: steer
kind: choice
thread: cloud-setup
agent: b27ca88a-a3d3-4d4c-bc37-7a7efd2eee4e
cwd: .
asked at: 2026-10-24T10:52:22.869050+00:00

## Context

You said you will restart the thread yourself, so the default is to do
nothing. Tap fix-home if you want the three hardcoded mise paths fixed now.

## Files

- /home/skogix/.local/src/cli/bin/config

## Options

- wait — do nothing until you start the new thread
+ no surprises  (doing)
- fix-home — replace /home/skogix with $HOME in ~/.local/src/cli bin/config
+ small, concrete
- edits a repo outside this one

## Answer

fix-home
answered at: 2026-10-24T10:55:54.519044+00:00
