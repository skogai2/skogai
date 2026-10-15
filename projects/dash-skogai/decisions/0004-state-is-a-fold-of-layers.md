---
type: Decision
title: "State is a fold of layers"
description: "Resolved state is fold(merge, [base, global, local]), where the later layer wins and no layer inherits from another."
status: stable
tags: [decision, layers]
generated: { by: "claude-code/claude-opus-5-5", at: "2026-10-15T00:00:00Z" }
---

Resolved state is fold(merge, [base, global, local]), where the later layer wins and no layer inherits from another.
