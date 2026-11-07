---
title: "Don't keep copies of files owned by the shared skogai-core plugin"
author: Emil
date: 2026-11-07
standing: true
id: l-423c8aa3
scope: repo
status: active
src: init-review
---

## Tried and ruled out
- Local copies of validate-settings, the example settings file and the git-diff doc drifted from the plugin versions, which were a superset. They were deleted and docs now point at the plugin.
- In the code: Reference the skogai-core plugin's `DIFF-AS-CONTEXT.md` (skogai2/marketplace) instead of copying. Don't re-add `dash-skogai/validate-settings.sh` or `docs/concepts/git-diff-communication.md`.

_From PR #4 here, Oct 16._
