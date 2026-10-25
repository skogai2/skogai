---
description: Scratch files go in ./tmp/, never /tmp/
priority: 0
---
- Write throwaway/scratch output to `./tmp/` (repo-local), not `/tmp/`.
- This keeps scratch work attached to the working directory and recoverable if a session is
  interrupted, instead of leaking into the global temp namespace.
