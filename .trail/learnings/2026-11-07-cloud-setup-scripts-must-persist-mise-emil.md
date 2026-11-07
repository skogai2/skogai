---
title: "Cloud setup scripts must persist mise trust and PATH beyond the script's own shell"
author: Emil
date: 2026-11-07
standing: true
id: l-3c780292
scope: repo
status: active
src: init-review
---

## Watch out
- The old script ran trust, install and activate in its own shell, so none of it reached the session. The repo config stayed untrusted and the shims were empty.
- In the code: Trust via global `trusted_config_paths = ["/home/user"]`, set `experimental = true`, and put mise shims on PATH at the top of `~/.bashrc` above the non-interactive early return. Don't use `eval "$(mise activate bash)"` or bare `mise activate`. See `wip/mise/current-claude-code-setup-script.sh`.

_From PRs #10, #2 here, Oct 20._
