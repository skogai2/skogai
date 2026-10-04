---
type: Reference
title: Submodules
description: The two git submodules under projects/, with URLs and pinned commits at setup time.
tags: [skogai, submodules, okf]
---

# Submodules

`.gitmodules` declares two submodules. Both are Open Knowledge Format (OKF) projects.
Source: `.gitmodules`.

| Path | Remote | Pinned commit at setup (2026-10-04) |
| --- | --- | --- |
| `projects/ofk-claude` | `https://github.com/skogai2/okf` | `8e3187875e66051bb52f91a5ed27342e2c3208da` (`main`) |
| `projects/ofk-tools` | `https://github.com/skogai2/okf2` | `1d6b0e40c78d7fb1ec2dd459301876adcb499846` (`main`) |

## Notes

* Commits come from `git submodule status`. The pinned commit can change when the
  submodule is updated. Re-check it before you cite it.
* Submodule content is not copied into this wiki. Read it in the submodule directory.
