---
name: rejection-is-a-value
description: "invalid input is a normal answer, not an error exit; exit codes only for the unexpected; same output whatever exists."
metadata:
  node_type: memory
  created: 2026-10-26
  stale_after: 2026-11-26
  originSessionId: 60195111-38b6-4922-8237-737329176cbe
  modified: 2026-10-26T11:52:13.347Z
---

skogix, 2026-10-26: an evaluator that rejects input has succeeded. exit codes
are for unexpected errors only, not for validation. almost all possible input
is wrong, so handling it is the normal path, not a panic.

**Why:** a validation layer that treats rejection as failure isn't doing its
job. also security: `rm /root/.ssh/id_rsa` must not answer differently from
`rm /root/.ssh/id_rsa2`, or the answer leaks what exists.

stdout always carries a string, empty on rejection; the error message goes
on stderr. mixing them (`2>&1` by habit) corrupts the value a caller reads.

**How to apply:** keep stdout and stderr apart; don't call `argc --argc-eval` exiting 0 on bad input a
bug. rejection goes out as a value; validation never depends on hidden state.
related: [[concepts-not-mechanisms]], [[functional-state-as-diff]].

On expiry: promote to a principle once principle is defined, or forget.
