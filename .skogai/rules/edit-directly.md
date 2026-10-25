---
description: Edit files directly, never via sed/awk/perl
priority: 0
---
- Never patch files with `sed`, `awk`, `perl -i`, or similar stream-editing one-liners.
- Use a direct file edit (Edit/Write) instead, so the change is reviewable and doesn't rest on an
  unverified pattern match.
- If a file's contents look surprisingly empty, missing, or already "wrong," read the actual
  definition before assuming it's a bug — in this repo that's often deliberate precision, not an
  oversight.
